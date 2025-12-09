package com.blooddonation.util;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import com.blooddonation.service.BloodStockService;
import com.blooddonation.service.NotificationService;

/**
 * Utility class for scheduling tasks in the blood donation system
 */
public class SchedulerUtil {
    
    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(5);
    private static final Timer timer = new Timer("BloodDonationScheduler", true);
    
    /**
     * Schedule a task to run at a specific time
     */
    public static void scheduleTask(TimerTask task, Date time) {
        timer.schedule(task, time);
    }
    
    /**
     * Schedule a task to run after a delay
     */
    public static void scheduleTask(TimerTask task, long delay) {
        timer.schedule(task, delay);
    }
    
    /**
     * Schedule a task to run repeatedly
     */
    public static void scheduleRepeatingTask(TimerTask task, long delay, long period) {
        timer.schedule(task, delay, period);
    }
    
    /**
     * Schedule a task using ScheduledExecutorService
     */
    public static void scheduleWithExecutor(Runnable task, long delay, TimeUnit unit) {
        scheduler.schedule(task, delay, unit);
    }
    
    /**
     * Schedule a repeating task using ScheduledExecutorService
     */
    public static void scheduleRepeatingWithExecutor(Runnable task, long initialDelay, long period, TimeUnit unit) {
        scheduler.scheduleAtFixedRate(task, initialDelay, period, unit);
    }
    
    /**
     * Schedule a task to run daily at a specific time
     */
    public static void scheduleDailyTask(TimerTask task, int hour, int minute) {
        // Calculate delay until next occurrence
        long delay = calculateDelayUntilNext(hour, minute);
        long period = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
        
        timer.schedule(task, delay, period);
    }
    
    /**
     * Schedule a task to run weekly
     */
    public static void scheduleWeeklyTask(TimerTask task, int dayOfWeek, int hour, int minute) {
        // Calculate delay until next occurrence
        long delay = calculateDelayUntilNextWeekly(dayOfWeek, hour, minute);
        long period = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds
        
        timer.schedule(task, delay, period);
    }
    
    /**
     * Cancel all scheduled tasks
     */
    public static void cancelAllTasks() {
        timer.cancel();
        scheduler.shutdown();
    }
    
    /**
     * Shutdown the scheduler gracefully
     */
    public static void shutdown() {
        timer.cancel();
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }
    
    /**
     * Calculate delay until next occurrence of a specific time
     */
    private static long calculateDelayUntilNext(int hour, int minute) {
        Calendar now = Calendar.getInstance();
        Calendar next = Calendar.getInstance();
        next.set(Calendar.HOUR_OF_DAY, hour);
        next.set(Calendar.MINUTE, minute);
        next.set(Calendar.SECOND, 0);
        next.set(Calendar.MILLISECOND, 0);
        
        if (next.before(now)) {
            next.add(Calendar.DAY_OF_MONTH, 1); // Add 24 hours
        }
        
        return next.getTimeInMillis() - now.getTimeInMillis();
    }
    
    /**
     * Calculate delay until next occurrence of a specific day and time
     */
    private static long calculateDelayUntilNextWeekly(int dayOfWeek, int hour, int minute) {
        Calendar now = Calendar.getInstance();
        Calendar next = Calendar.getInstance();
        
        int currentDay = now.get(Calendar.DAY_OF_WEEK);
        int daysUntilTarget = (dayOfWeek - currentDay + 7) % 7;
        
        next.add(Calendar.DAY_OF_MONTH, daysUntilTarget);
        next.set(Calendar.HOUR_OF_DAY, hour);
        next.set(Calendar.MINUTE, minute);
        next.set(Calendar.SECOND, 0);
        next.set(Calendar.MILLISECOND, 0);
        
        if (next.before(now)) {
            next.add(Calendar.DAY_OF_MONTH, 7); // Add 7 days
        }
        
        return next.getTimeInMillis() - now.getTimeInMillis();
    }
    
    /**
     * Schedule blood expiry check task
     */
    public static void scheduleBloodExpiryCheck() {
        scheduleDailyTask(new TimerTask() {
            @Override
            public void run() {
                try {
                    // Check for blood units expiring soon
                    BloodStockService.checkExpiringBlood();
                } catch (Exception e) {
                    System.err.println("Error checking blood expiry: " + e.getMessage());
                }
            }
        }, 9, 0); // Run at 9:00 AM daily
    }
    
    /**
     * Schedule low stock alert task
     */
    public static void scheduleLowStockCheck() {
        scheduleDailyTask(new TimerTask() {
            @Override
            public void run() {
                try {
                    // Check for low stock levels
                    BloodStockService.checkLowStock();
                } catch (Exception e) {
                    System.err.println("Error checking low stock: " + e.getMessage());
                }
            }
        }, 10, 0); // Run at 10:00 AM daily
    }
    
    /**
     * Schedule appointment reminder task
     */
    public static void scheduleAppointmentReminders() {
        scheduleDailyTask(new TimerTask() {
            @Override
            public void run() {
                try {
                    // Send appointment reminders
                    NotificationService.sendAppointmentReminders();
                } catch (Exception e) {
                    System.err.println("Error sending appointment reminders: " + e.getMessage());
                }
            }
        }, 8, 0); // Run at 8:00 AM daily
    }
    
    /**
     * Initialize all scheduled tasks
     */
    public static void initializeScheduledTasks() {
        scheduleBloodExpiryCheck();
        scheduleLowStockCheck();
        scheduleAppointmentReminders();
        
        System.out.println("Scheduled tasks initialized successfully");
    }
}
