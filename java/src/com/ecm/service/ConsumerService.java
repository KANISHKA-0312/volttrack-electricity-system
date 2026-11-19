package com.ecm.service;

import com.ecm.model.Consumer;
import com.ecm.exception.ConsumerNotFoundException;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Service managing consumer profiles, directory searches, and registration.
 * Utilizes Collections Framework (Map, List) for memory management.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class ConsumerService {
    private final Map<Integer, Consumer> consumerMap = new ConcurrentHashMap<>();
    private final AtomicInteger idSequence = new AtomicInteger(1000);

    public Consumer registerConsumer(Consumer consumer) {
        int newId = idSequence.incrementAndGet();
        consumer.setConsumerId(newId);
        if (consumer.getConsumerNumber() == null || consumer.getConsumerNumber().isEmpty()) {
            consumer.setConsumerNumber(String.format("EB-2026-%04d", newId));
        }
        consumerMap.put(newId, consumer);
        return consumer;
    }

    public Consumer getConsumerById(int id) throws ConsumerNotFoundException {
        Consumer consumer = consumerMap.get(id);
        if (consumer == null) {
            throw new ConsumerNotFoundException("No consumer found with ID: " + id);
        }
        return consumer;
    }

    public Optional<Consumer> getConsumerByNumber(String consumerNumber) {
        return consumerMap.values().stream()
                .filter(c -> c.getConsumerNumber().equalsIgnoreCase(consumerNumber))
                .findFirst();
    }

    public List<Consumer> getAllConsumers() {
        return new ArrayList<>(consumerMap.values());
    }

    public boolean deleteConsumer(int id) {
        return consumerMap.remove(id) != null;
    }
}
