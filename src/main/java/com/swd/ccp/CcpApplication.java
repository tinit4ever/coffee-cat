package com.swd.ccp;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@SpringBootApplication
@RequiredArgsConstructor
public class CcpApplication {

    private final AccountStatusRepo accountStatusRepo;

    private final AccountRepo accountRepo;

    private final CustomerRepo customerRepo;

    private final ManagerRepo managerRepo;

    private final TokenRepo tokenRepo;

    private final JWTService jwtService;

    public static void main(String[] args) {
        SpringApplication.run(CcpApplication.class, args);
    }

    @Bean
    public CommandLineRunner initData() {
        return new CommandLineRunner() {
            @Override
            public void run(String... args) throws Exception {
                List<AccountStatus> accountStatusList = new ArrayList<>();
                List<Account> accountList = new ArrayList<>();
                List<Token> tokenList = new ArrayList<>();

                accountStatusList.add(AccountStatus.builder().status("active").build());
                accountStatusList.add(AccountStatus.builder().status("inactive").build());
                accountStatusRepo.saveAll(accountStatusList);

                Account admin = Account
                        .builder()
                        .email("admin@gmail.com")
                        .name("Admin")
                        .password("admin")
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.ADMIN)
                        .build();

                Account owner = Account
                        .builder()
                        .email("owner@gmail.com")
                        .name("Shop owner")
                        .password("owner")
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.OWNER)
                        .build();

                Account staff = Account
                        .builder()
                        .email("staff@gmail.com")
                        .name("Staff")
                        .password("staff")
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.STAFF)
                        .build();

                Account customer = Account
                        .builder()
                        .email("customer@gmail.com")
                        .name("Customer")
                        .password("customer")
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.CUSTOMER)
                        .build();

                String admin_token = jwtService.generateToken(admin);
                String owner_token = jwtService.generateToken(owner);
                String staff_token = jwtService.generateToken(staff);
                String customer_token = jwtService.generateToken(customer);

                String admin_refresh_token = jwtService.generateRefreshToken(admin);
                String owner_refresh_token = jwtService.generateRefreshToken(owner);
                String staff_refresh_token = jwtService.generateRefreshToken(staff);
                String customer_refresh_token = jwtService.generateRefreshToken(customer);

                accountList.add(admin);
                accountList.add(owner);
                accountList.add(staff);
                accountList.add(customer);

                accountRepo.saveAll(accountList);

                Token admin_access = Token.builder().account(admin).token(admin_token).type("access").status(1).build();
                Token admin_refresh = Token.builder().account(admin).token(admin_refresh_token).type("refresh").status(1).build();
                Token owner_access = Token.builder().account(owner).token(owner_token).type("access").status(1).build();
                Token owner_refresh = Token.builder().account(owner).token(owner_refresh_token).type("refresh").status(1).build();
                Token staff_access = Token.builder().account(staff).token(staff_token).type("access").status(1).build();
                Token staff_refresh = Token.builder().account(staff).token(staff_refresh_token).type("refresh").status(1).build();
                Token customer_access = Token.builder().account(customer).token(customer_token).type("access").status(1).build();
                Token customer_refresh = Token.builder().account(customer).token(customer_refresh_token).type("refresh").status(1).build();

                tokenList.add(admin_access);
                tokenList.add(admin_refresh);
                tokenList.add(owner_access);
                tokenList.add(owner_refresh);
                tokenList.add(staff_access);
                tokenList.add(staff_refresh);
                tokenList.add(customer_access);
                tokenList.add(customer_refresh);

                tokenRepo.saveAll(tokenList);

                customerRepo.save(
                        Customer.builder()
                                .account(customer)
                                .phone("090909090909")
                                .gender("Male")
                                .dob(new Date(System.currentTimeMillis()))
                                .build()
                );

                System.out.println("\n# ADMIN token: " + admin_token);
                System.out.println("# OWNER token: " + owner_token);
                System.out.println("# STAFF token: " + staff_token);
                System.out.println("# CUSTOMER token: " + customer_token);
            }
        };
    }

}
