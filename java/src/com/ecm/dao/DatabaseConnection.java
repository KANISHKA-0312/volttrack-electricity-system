package com.ecm.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection manager for JDBC connectivity.
 * Demonstrates Unit 4 Database Connection and JPA/JDBC concepts.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class DatabaseConnection {
    // Configurable parameters for MySQL / SQLite connection
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/electricity_db?useSSL=false&serverTimezone=UTC";
    private static final String SQLITE_URL = "jdbc:sqlite:electricity_db.db";
    private static final String USER = "root";
    private static final String PASSWORD = "password";

    private static Connection connection = null;

    public static Connection getConnection() {
        if (connection != null) {
            return connection;
        }
        try {
            // Attempt MySQL connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(MYSQL_URL, USER, PASSWORD);
            System.out.println("[DB] Connected to MySQL database successfully.");
        } catch (ClassNotFoundException | SQLException e) {
            // Graceful fallback notice for offline lab runs
            // System.out.println("[DB] Offline/Stand-alone mode: In-memory repository active.");
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ignored) {}
        }
    }
}
