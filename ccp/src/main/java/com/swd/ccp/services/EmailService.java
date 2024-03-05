package com.swd.ccp.services;

import jakarta.mail.MessagingException;

public interface EmailService {

    void sendOwnerAccountEmail(String recipientEmail, String email, String password) throws MessagingException, Exception;
}
