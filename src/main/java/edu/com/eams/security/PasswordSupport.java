package edu.com.eams.security;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.StringUtils;

public final class PasswordSupport {

    private PasswordSupport() {
    }

    public static boolean matches(PasswordEncoder passwordEncoder, String rawPassword, String storedPassword) {
        if (!StringUtils.hasText(rawPassword) || !StringUtils.hasText(storedPassword)) {
            return false;
        }
        if (isEncoded(storedPassword)) {
            return passwordEncoder.matches(rawPassword, storedPassword);
        }
        return storedPassword.equals(rawPassword);
    }

    public static String encodeIfNecessary(PasswordEncoder passwordEncoder, String password) {
        if (!StringUtils.hasText(password) || isEncoded(password)) {
            return password;
        }
        return passwordEncoder.encode(password);
    }

    private static boolean isEncoded(String password) {
        return password.startsWith("$2a$")
                || password.startsWith("$2b$")
                || password.startsWith("$2y$");
    }
}
