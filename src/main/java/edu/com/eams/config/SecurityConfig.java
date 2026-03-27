package edu.com.eams.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.com.eams.comm.RetJson;
import edu.com.eams.security.SessionAuthenticationFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Configuration
public class SecurityConfig {

    private final SessionAuthenticationFilter sessionAuthenticationFilter;
    private final AppCorsProperties appCorsProperties;
    private final ObjectMapper objectMapper;

    public SecurityConfig(SessionAuthenticationFilter sessionAuthenticationFilter,
                          AppCorsProperties appCorsProperties,
                          ObjectMapper objectMapper) {
        this.sessionAuthenticationFilter = sessionAuthenticationFilter;
        this.appCorsProperties = appCorsProperties;
        this.objectMapper = objectMapper;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .logout(AbstractHttpConfigurer::disable)
                .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.sameOrigin()))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/",
                                "/error",
                                "/favicon.ico",
                                "/static/**"
                        ).permitAll()
                        .requestMatchers("/api/auth/login").permitAll()
                        .requestMatchers("/api/auth/**").authenticated()
                        .requestMatchers("/api/dashboard/**").authenticated()
                        .requestMatchers("/api/salaries/mine").authenticated()
                        .requestMatchers("/api/profile/**", "/api/leaves/**").authenticated()
                        .requestMatchers(
                                "/api/employees/**",
                                "/api/departments/**",
                                "/api/postlevels/**",
                                "/api/users/**",
                                "/api/salaries/**"
                        ).hasRole("ADMIN")
                        .requestMatchers("/api/attendance/check-in", "/api/attendance/check-out", "/api/attendance/**")
                        .authenticated()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .anyRequest().authenticated()
                )
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) ->
                                handleUnauthorized(request, response))
                        .accessDeniedHandler((request, response, accessDeniedException) ->
                                handleForbidden(request, response))
                )
                .addFilterBefore(sessionAuthenticationFilter, AnonymousAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(appCorsProperties.getAllowedOrigins());
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (expectsJson(request)) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, new RetJson<>(401, "Please login first", null));
            return;
        }
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.TEXT_HTML_VALUE);
        response.getWriter().write("""
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"><title>401</title></head>
                <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 80px;">
                    <h1>401</h1>
                    <p>Please login from the frontend application.</p>
                </body>
                </html>
                """);
    }

    private void handleForbidden(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (expectsJson(request)) {
            writeJson(response, HttpServletResponse.SC_FORBIDDEN, new RetJson<>(403, "Access denied", null));
            return;
        }
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.TEXT_HTML_VALUE);
        response.getWriter().write("""
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"><title>403</title></head>
                <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 80px;">
                    <h1>403</h1>
                    <p>Access denied.</p>
                    <button onclick="history.back()">Back</button>
                </body>
                </html>
                """);
    }

    private boolean expectsJson(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");
        String contentType = request.getContentType();
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();

        return (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE))
                || "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (contentType != null && contentType.contains(MediaType.APPLICATION_JSON_VALUE))
                || uri.startsWith(contextPath + "/api/");
    }

    private void writeJson(HttpServletResponse response, int httpStatus, RetJson<?> body) throws IOException {
        response.setStatus(httpStatus);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(response.getWriter(), body);
    }
}
