package com.envios.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.envios.model.Cliente;
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
}