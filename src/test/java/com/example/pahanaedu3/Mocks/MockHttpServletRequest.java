package com.example.pahanaedu3.Mocks;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.security.Principal;
import java.util.*;

public class MockHttpServletRequest implements HttpServletRequest {

    private Map<String, String[]> parameters = new HashMap<>();
    private Map<String, Object> attributes = new HashMap<>();
    private MockHttpSession session = new MockHttpSession();

    public String forwardedPath;

    public void setParameter(String name, String value) {
        parameters.put(name, new String[]{value});
    }

    public void setParameter(String name, String[] values) {
        parameters.put(name, values);
    }

    @Override
    public String getParameter(String name) {
        String[] values = parameters.get(name);
        return (values != null && values.length > 0) ? values[0] : null;
    }

    /**
     * @return
     */
    public Enumeration<String> getParameterNames() {
        return null;
    }

    @Override
    public String[] getParameterValues(String name) {
        return parameters.get(name);
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        return parameters;
    }

    @Override
    public Object getAttribute(String name) {
        return attributes.get(name);
    }

    @Override
    public void setAttribute(String name, Object o) {
        attributes.put(name, o);
    }

    @Override
    public void removeAttribute(String name) {
        attributes.remove(name);
    }

    @Override
    public Enumeration<String> getAttributeNames() {
        return Collections.enumeration(attributes.keySet());
    }

    @Override
    public HttpSession getSession(boolean create) {
        return session;
    }

    @Override
    public HttpSession getSession() {
        return session;
    }

    /**
     * @return
     */
    public String changeSessionId() {
        return "";
    }

    /**
     * @return
     */
    public boolean isRequestedSessionIdValid() {
        return false;
    }

    /**
     * @return
     */
    public boolean isRequestedSessionIdFromCookie() {
        return false;
    }

    /**
     * @return
     */
    public boolean isRequestedSessionIdFromURL() {
        return false;
    }

    /**
     * @param httpServletResponse
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public boolean authenticate(HttpServletResponse httpServletResponse) throws IOException, ServletException {
        return false;
    }

    /**
     * @param s
     * @param s1
     * @throws ServletException
     */
    public void login(String s, String s1) throws ServletException {

    }

    /**
     * @throws ServletException
     */
    public void logout() throws ServletException {

    }

    /**
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public Collection<Part> getParts() throws IOException, ServletException {
        return List.of();
    }

    /**
     * @param s
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public Part getPart(String s) throws IOException, ServletException {
        return null;
    }

    @Override
    public RequestDispatcher getRequestDispatcher(String path) {
        return new RequestDispatcher() {
            @Override
            public void forward(ServletRequest req, ServletResponse res) {
                forwardedPath = path;
            }

            @Override
            public void include(ServletRequest req, ServletResponse res) {
                // do nothing
            }
        };
    }

    // --- Stubbed methods required by HttpServletRequest ---
    @Override public String getAuthType() { return null; }
    @Override public Cookie[] getCookies() { return new Cookie[0]; }
    @Override public long getDateHeader(String name) { return 0; }
    @Override public String getHeader(String name) { return null; }
    @Override public Enumeration<String> getHeaders(String name) { return Collections.emptyEnumeration(); }
    @Override public Enumeration<String> getHeaderNames() { return Collections.emptyEnumeration(); }
    @Override public int getIntHeader(String name) { return 0; }

    /**
     * @return
     */
    public HttpServletMapping getHttpServletMapping() {
        return HttpServletRequest.super.getHttpServletMapping();
    }

    @Override public String getMethod() { return "POST"; }
    @Override public String getPathInfo() { return null; }
    @Override public String getPathTranslated() { return null; }

    /**
     * @return
     */
    public PushBuilder newPushBuilder() {
        return HttpServletRequest.super.newPushBuilder();
    }

    @Override public String getContextPath() { return ""; }
    @Override public String getQueryString() { return null; }
    @Override public String getRemoteUser() { return null; }
    @Override public boolean isUserInRole(String role) { return false; }
    @Override public Principal getUserPrincipal() { return null; }
    @Override public String getRequestedSessionId() { return null; }
    @Override public String getRequestURI() { return null; }
    @Override public StringBuffer getRequestURL() { return null; }
    @Override public String getServletPath() { return ""; }
    @Override public String getProtocol() { return null; }
    @Override public String getScheme() { return null; }
    @Override public String getServerName() { return null; }
    @Override public int getServerPort() { return 0; }
    @Override public BufferedReader getReader() { return null; }
    @Override public String getRemoteAddr() { return null; }
    @Override public String getRemoteHost() { return null; }
    @Override public void setCharacterEncoding(String env) {}

    /**
     * @param encoding
     */
    public void setCharacterEncoding(Charset encoding) {
        HttpServletRequest.super.setCharacterEncoding(encoding);
    }

    @Override public String getCharacterEncoding() { return null; }
    @Override public int getContentLength() { return 0; }
    @Override public long getContentLengthLong() { return 0; }
    @Override public String getContentType() { return null; }
    @Override public ServletInputStream getInputStream() { return null; }
    @Override public Locale getLocale() { return null; }
    @Override public Enumeration<Locale> getLocales() { return Collections.emptyEnumeration(); }
    @Override public boolean isSecure() { return false; }
    @Override public int getRemotePort() { return 0; }
    @Override public String getLocalName() { return null; }
    @Override public String getLocalAddr() { return null; }
    @Override public int getLocalPort() { return 0; }
    @Override public ServletContext getServletContext() { return null; }
    @Override public AsyncContext startAsync() { return null; }
    @Override public AsyncContext startAsync(ServletRequest servletRequest, ServletResponse servletResponse) { return null; }
    @Override public boolean isAsyncStarted() { return false; }
    @Override public boolean isAsyncSupported() { return false; }
    @Override public AsyncContext getAsyncContext() { return null; }
    @Override public DispatcherType getDispatcherType() { return null; }

    /**
     * @return
     */
    public String getRequestId() {
        return "";
    }

    /**
     * @return
     */
    public String getProtocolRequestId() {
        return "";
    }

    /**
     * @return
     */
    public ServletConnection getServletConnection() {
        return null;
    }

    @Override public <T extends HttpUpgradeHandler> T upgrade(Class<T> handlerClass) { return null; }

    /**
     * @return
     */
    public Map<String, String> getTrailerFields() {
        return HttpServletRequest.super.getTrailerFields();
    }

    /**
     * @return
     */
    public boolean isTrailerFieldsReady() {
        return HttpServletRequest.super.isTrailerFieldsReady();
    }

    public void setSession(MockHttpSession session) {
    }
}
