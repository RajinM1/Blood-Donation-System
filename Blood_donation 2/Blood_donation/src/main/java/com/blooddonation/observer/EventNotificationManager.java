package com.blooddonation.observer;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Subject class that manages observers and notifies them of events
 * Implements the Observer pattern
 */
public class EventNotificationManager {
    
    // Thread-safe list to handle concurrent access
    private final List<EventObserver> observers = new CopyOnWriteArrayList<>();
    
    // Singleton instance
    private static EventNotificationManager instance;
    
    private EventNotificationManager() {}
    
    /**
     * Get singleton instance of EventNotificationManager
     */
    public static synchronized EventNotificationManager getInstance() {
        if (instance == null) {
            instance = new EventNotificationManager();
        }
        return instance;
    }
    
    /**
     * Add an observer to receive event notifications
     * @param observer The observer to add
     */
    public void addObserver(EventObserver observer) {
        if (observer != null && !observers.contains(observer)) {
            observers.add(observer);
            System.out.println("Observer added: " + observer.getObserverName());
        }
    }
    
    /**
     * Remove an observer from receiving notifications
     * @param observer The observer to remove
     */
    public void removeObserver(EventObserver observer) {
        if (observers.remove(observer)) {
            System.out.println("Observer removed: " + observer.getObserverName());
        }
    }
    
    /**
     * Notify all observers of an event
     * @param event The event that occurred
     * @param data Additional data related to the event
     */
    public void notifyObservers(SystemEvent event, Object data) {
        System.out.println("\n[EVENT] " + event.getDescription() + " → Notifying " + observers.size() + " observers");
        System.out.println("────────────────────────────────────────────────────────────");
        
        for (EventObserver observer : observers) {
            try {
                observer.onEvent(event, data);
            } catch (Exception e) {
                System.err.println("Error notifying observer " + observer.getObserverName() + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.out.println("────────────────────────────────────────────────────────────\n");
    }
    
    /**
     * Get list of all registered observers
     * @return List of observer names
     */
    public List<String> getObserverNames() {
        List<String> names = new ArrayList<>();
        for (EventObserver observer : observers) {
            names.add(observer.getObserverName());
        }
        return names;
    }
    
    /**
     * Get the number of registered observers
     * @return Number of observers
     */
    public int getObserverCount() {
        return observers.size();
    }
}