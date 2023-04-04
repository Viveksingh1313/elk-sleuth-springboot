package com.elk.os.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.elk.os.api.entity.Order;

public interface OrderRepository extends JpaRepository<Order,Integer> {
}
