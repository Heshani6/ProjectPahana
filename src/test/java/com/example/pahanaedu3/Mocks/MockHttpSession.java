package com.example.pahanaedu3.Mocks;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.Enumeration;
import java.util.Vector;

public class MockHttpSession implements HttpSession {
    private Map<String, Object> attributes = new HashMap<>();

    @Override
    public Object getAttribute(String name) {
        return attributes.get(name);
    }

    @Override
    public void setAttribute(String name, Object value) {
        attributes.put(name, value);
    }

    @Override
    public void removeAttribute(String name) {
        attributes.remove(name);
    }

    @Override
    public int getMaxInactiveInterval() {
        return 900;
    }

    // All other HttpSession methods with dummy implementations
    @Override public long getCreationTime() { return 0; }
    @Override public String getId() { return "test-session-id"; }
    @Override public long getLastAccessedTime() { return 0; }
    @Override public ServletContext getServletContext() { return null; }
    @Override public void setMaxInactiveInterval(int interval) {}
    @Override public void invalidate() {}
    @Override public boolean isNew() { return false; }
    @Override public Enumeration<String> getAttributeNames() { return new Vector<String>(attributes.keySet()).elements(); }
}