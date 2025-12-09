package com.blooddonation.observer;

/**
 * Observer interface for handling system events
 */
public interface EventObserver {
    /**
     * Called when an event occurs in the system
     * @param event The event that occurred
     * @param data Additional data related to the event
     */
    void onEvent(SystemEvent event, Object data);
    
    /**
     * Get the observer's name for identification
     * @return Observer name
     */
    String getObserverName();
}