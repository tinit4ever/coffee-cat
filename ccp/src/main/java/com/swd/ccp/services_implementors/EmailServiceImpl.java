package com.swd.ccp.services_implementors;

import com.swd.ccp.services.EmailService;
import com.swd.ccp.services.FileService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {

    private final JavaMailSender mailSender;
    private final FileService fileService;
    @Override
    public void sendOwnerAccountEmail(String recipientEmail, String email, String password) throws MessagingException, Exception {
        MimeMessage message = mailSender.createMimeMessage();

        message.setFrom(new InternetAddress("exceptionkindom@gmail.com"));
        message.setRecipients(MimeMessage.RecipientType.TO, recipientEmail);
        message.setSubject("CCP SHOP ACCOUNT");

        String htmlContent = fileService.readEmailTemplate(email, password);
        message.setContent(htmlContent, "text/html; charset=utf-8");

        mailSender.send(message);
    }
}
