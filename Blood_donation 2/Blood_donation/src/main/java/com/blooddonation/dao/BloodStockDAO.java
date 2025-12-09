package com.blooddonation.dao;

import com.blooddonation.model.BloodStock;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BloodStockDAO {
    public List<BloodStock> getAllBloodStock() throws SQLException {
        List<BloodStock> stocks = new ArrayList<>();
        String query = "SELECT * FROM blood_stock ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodStock stock = new BloodStock();
                stock.setId(rs.getInt("id"));
                stock.setBloodGroup(rs.getString("blood_group"));
                stock.setQuantity(rs.getInt("quantity"));
                stock.setExpiryDate(rs.getDate("expiry_date"));
                stock.setCollectionDate(rs.getDate("collection_date"));
                stock.setDonorId(rs.getInt("donor_id"));
                stock.setStatus(rs.getString("status"));
                stock.setVolume(rs.getDouble("volume"));
                stock.setCreatedAt(rs.getTimestamp("created_at"));
                stock.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // Set default values for fields that don't exist in DB but are expected by the model
                stock.setScreeningResult("NEGATIVE"); // Default value since this field doesn't exist in DB
                stock.setNotes(null);
                
                stocks.add(stock);
            }
        }
        return stocks;
    }

    public int getTotalUnits() throws SQLException {
        String query = "SELECT SUM(quantity) FROM blood_stock";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getTotalBloodUnits() throws SQLException {
        return getTotalUnits();
    }
    
    public Map<String, Integer> getBloodStockByGroup() throws SQLException {
        Map<String, Integer> stockByGroup = new HashMap<>();
        String query = "SELECT blood_group, SUM(quantity) as total FROM blood_stock GROUP BY blood_group";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                stockByGroup.put(rs.getString("blood_group"), rs.getInt("total"));
            }
        }
        return stockByGroup;
    }

    public void addBloodStock(BloodStock stock) throws SQLException {
        String query = "INSERT INTO blood_stock (blood_group, quantity, volume, expiry_date, collection_date, donor_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, stock.getBloodGroup());
            stmt.setInt(2, stock.getQuantity());
            stmt.setDouble(3, stock.getVolume() > 0 ? stock.getVolume() : 450.0);
            stmt.setDate(4, new java.sql.Date(stock.getExpiryDate().getTime()));
            stmt.setDate(5, stock.getCollectionDate() != null ? new java.sql.Date(stock.getCollectionDate().getTime()) : null);
            stmt.setInt(6, stock.getDonorId());
            stmt.setString(7, stock.getStatus());
            stmt.executeUpdate();
        }
    }

    public void updateBloodStock(BloodStock stock) throws SQLException {
        String query = "UPDATE blood_stock SET quantity = ?, expiry_date = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stock.getQuantity());
            stmt.setDate(2, new java.sql.Date(stock.getExpiryDate().getTime()));
            stmt.setInt(3, stock.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteBloodStock(int stockId) throws SQLException {
        String query = "DELETE FROM blood_stock WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stockId);
            stmt.executeUpdate();
        }
    }

    public BloodStock getBloodStockById(int stockId) throws SQLException {
        String query = "SELECT * FROM blood_stock WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stockId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BloodStock stock = new BloodStock();
                    stock.setId(rs.getInt("id"));
                    stock.setBloodGroup(rs.getString("blood_group"));
                    stock.setQuantity(rs.getInt("quantity"));
                    stock.setExpiryDate(rs.getDate("expiry_date"));
                    stock.setCollectionDate(rs.getDate("collection_date"));
                    stock.setDonorId(rs.getInt("donor_id"));
                    stock.setStatus(rs.getString("status"));
                    stock.setVolume(rs.getDouble("volume"));
                    stock.setCreatedAt(rs.getTimestamp("created_at"));
                    stock.setUpdatedAt(rs.getTimestamp("updated_at"));
                    
                    // Set default values for fields that don't exist in DB
                    stock.setScreeningResult("NEGATIVE");
                    stock.setNotes(null);
                    
                    return stock;
                }
            }
        }
        return null;
    }

    public List<BloodStock> getBloodStockByGroup(String bloodGroup) throws SQLException {
        List<BloodStock> stocks = new ArrayList<>();
        String query = "SELECT * FROM blood_stock WHERE blood_group = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, bloodGroup);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodStock stock = new BloodStock();
                    stock.setId(rs.getInt("id"));
                    stock.setBloodGroup(rs.getString("blood_group"));
                    stock.setQuantity(rs.getInt("quantity"));
                    stock.setExpiryDate(rs.getDate("expiry_date"));
                    stock.setCollectionDate(rs.getDate("collection_date"));
                    stock.setDonorId(rs.getInt("donor_id"));
                    stock.setStatus(rs.getString("status"));
                    stock.setCreatedAt(rs.getTimestamp("created_at"));
                    stock.setUpdatedAt(rs.getTimestamp("updated_at"));
                    
                    // Set default values for fields that don't exist in DB
                    stock.setScreeningResult("NEGATIVE");
                    stock.setVolume(450.0);
                    stock.setNotes(null);
                    
                    stocks.add(stock);
                }
            }
        }
        return stocks;
    }

    public List<BloodStock> getUsableBloodStock() throws SQLException {
        List<BloodStock> stocks = new ArrayList<>();
        String query = "SELECT * FROM blood_stock WHERE expiry_date > NOW() AND status = 'AVAILABLE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodStock stock = new BloodStock();
                stock.setId(rs.getInt("id"));
                stock.setBloodGroup(rs.getString("blood_group"));
                stock.setQuantity(rs.getInt("quantity"));
                stock.setExpiryDate(rs.getDate("expiry_date"));
                stock.setCollectionDate(rs.getDate("collection_date"));
                stock.setDonorId(rs.getInt("donor_id"));
                stock.setStatus(rs.getString("status"));
                stock.setCreatedAt(rs.getTimestamp("created_at"));
                stock.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // Set default values for fields that don't exist in DB
                stock.setScreeningResult("NEGATIVE");
                stock.setVolume(450.0);
                stock.setNotes(null);
                
                stocks.add(stock);
            }
        }
        return stocks;
    }

    public List<BloodStock> getExpiringBloodStock(int days) throws SQLException {
        List<BloodStock> stocks = new ArrayList<>();
        String query = "SELECT * FROM blood_stock WHERE expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodStock stock = new BloodStock();
                    stock.setId(rs.getInt("id"));
                    stock.setBloodGroup(rs.getString("blood_group"));
                    stock.setQuantity(rs.getInt("quantity"));
                    stock.setExpiryDate(rs.getDate("expiry_date"));
                    stock.setCreatedAt(rs.getTimestamp("created_at"));
                    // Set default values for non-existent columns
                    stock.setCollectionDate(null);
                    stock.setStatus("AVAILABLE");
                    stock.setScreeningResult(null);
                    stock.setDonorId(0);
                    stock.setVolume(0.0);
                    stock.setNotes(null);
                    stock.setUpdatedAt(null);
                    stocks.add(stock);
                }
            }
        }
        return stocks;
    }

    public List<BloodStock> getExpiredBloodStock() throws SQLException {
        List<BloodStock> stocks = new ArrayList<>();
        String query = "SELECT * FROM blood_stock WHERE expiry_date < NOW()";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodStock stock = new BloodStock();
                stock.setId(rs.getInt("id"));
                stock.setBloodGroup(rs.getString("blood_group"));
                stock.setQuantity(rs.getInt("quantity"));
                stock.setExpiryDate(rs.getDate("expiry_date"));
                stock.setCollectionDate(rs.getDate("collection_date"));
                stock.setDonorId(rs.getInt("donor_id"));
                stock.setStatus("EXPIRED"); // Override status for expired items
                stock.setCreatedAt(rs.getTimestamp("created_at"));
                stock.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // Set default values for fields that don't exist in DB
                stock.setScreeningResult("NEGATIVE");
                stock.setVolume(450.0);
                stock.setNotes(null);
                
                stocks.add(stock);
            }
        }
        return stocks;
    }

    public int getTotalUnitsByBloodGroup(String bloodGroup) throws SQLException {
        String query = "SELECT SUM(quantity) FROM blood_stock WHERE blood_group = ? AND expiry_date > NOW() AND status = 'AVAILABLE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, bloodGroup);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean hasEnoughStock(String bloodGroup, int requiredQuantity) throws SQLException {
        int availableStock = getTotalUnitsByBloodGroup(bloodGroup);
        return availableStock >= requiredQuantity;
    }

    public void reduceStock(String bloodGroup, int quantity) throws SQLException {
        String query = "UPDATE blood_stock SET quantity = quantity - ? WHERE blood_group = ? AND status = 'AVAILABLE' AND expiry_date > NOW() ORDER BY expiry_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quantity);
            stmt.setString(2, bloodGroup);
            stmt.executeUpdate();
        }
    }

    public void markAsExpired(int stockId) throws SQLException {
        String query = "UPDATE blood_stock SET status = 'EXPIRED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stockId);
            stmt.executeUpdate();
        }
    }

    public void markAsDisposed(int stockId) throws SQLException {
        String query = "UPDATE blood_stock SET status = 'DISPOSED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stockId);
            stmt.executeUpdate();
        }
    }

    public List<BloodStock> getLowStockBloodGroups(int threshold) throws SQLException {
        List<BloodStock> lowStockGroups = new ArrayList<>();
        String query = "SELECT blood_group, SUM(quantity) as total FROM blood_stock WHERE status = 'AVAILABLE' AND expiry_date > NOW() GROUP BY blood_group HAVING total < ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, threshold);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodStock stock = new BloodStock();
                    stock.setBloodGroup(rs.getString("blood_group"));
                    stock.setQuantity(rs.getInt("total"));
                    lowStockGroups.add(stock);
                }
            }
        }
        return lowStockGroups;
    }

    public List<BloodStock> getLowStockItems() throws SQLException {
        return getLowStockBloodGroups(10); // Threshold of 10 units
    }

    public List<BloodStock> getExpiringStock(int days) throws SQLException {
        return getExpiringBloodStock(days);
    }
}