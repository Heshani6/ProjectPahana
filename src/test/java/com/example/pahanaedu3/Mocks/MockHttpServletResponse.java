package com.example.pahanaedu3.Mocks;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Collection;
import java.util.List;
import java.util.Locale;

public class MockHttpServletResponse implements HttpServletResponse{
    private String redirectUrl;
    private int status;
    private StringWriter stringWriter = new StringWriter();
    private PrintWriter writer = new PrintWriter(stringWriter);

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public int getStatus() {
        return status;
    }

    public String getOutput() {
        return stringWriter.toString();
    }

    @Override
    public void sendRedirect(String location) throws IOException {
        this.redirectUrl = location;
    }

    @Override
    public void sendRedirect(String location, int statusCode, boolean withBody) throws IOException {
        this.redirectUrl = location;
        this.status = statusCode;
    }

    @Override
    public void setStatus(int sc) {
        this.status = sc;
    }

    @Override
    public PrintWriter getWriter() throws IOException {
        return writer;
    }

    // --- Stubbed Methods from HttpServletResponse interface ---

    @Override public void setContentType(String type) {}
    @Override public void setBufferSize(int size) {}
    @Override public int getBufferSize() { return 0; }
    @Override public void flushBuffer() throws IOException {}
    @Override public boolean isCommitted() { return false; }
    @Override public void resetBuffer() {}
    @Override public void reset() {}
    @Override public void setCharacterEncoding(String charset) {}
    @Override public void setContentLength(int len) {}
    @Override public void setContentLengthLong(long len) {}
    @Override public String getCharacterEncoding() { return null; }
    @Override public String getContentType() { return null; }
    @Override public ServletOutputStream getOutputStream() throws IOException { return null; }
    @Override public void addCookie(Cookie cookie) {}
    @Override public boolean containsHeader(String name) { return false; }
    @Override public String encodeURL(String url) { return url; }
    @Override public String encodeRedirectURL(String url) { return url; }
    @Override public void sendError(int sc, String msg) throws IOException {}
    @Override public void sendError(int sc) throws IOException {}
    @Override public void setDateHeader(String name, long date) {}
    @Override public void addDateHeader(String name, long date) {}
    @Override public void setHeader(String name, String value) {}
    @Override public void addHeader(String name, String value) {}
    @Override public void setIntHeader(String name, int value) {}
    @Override public void addIntHeader(String name, int value) {}
    // REMOVED: setStatus(int sc, String sm)
    @Override public String getHeader(String name) { return null; }
    @Override public Collection<String> getHeaders(String name) { return List.of(); }
    @Override public Collection<String> getHeaderNames() { return List.of(); }
    @Override public void setLocale(Locale loc) {}
    @Override public Locale getLocale() { return null; }
}
