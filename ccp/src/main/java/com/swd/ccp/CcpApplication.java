package com.swd.ccp;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

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

    private final ShopRepo shopRepo;

    private final ShopStatusRepo shopStatusRepo;

    private final SeatRepo seatRepo;

    private final SeatStatusRepo seatStatusRepo;

    private final MenuRepo menuRepo;

    private final MenuItemRepo menuItemRepo;

    private final MenuItemStatusRepo menuItemStatusRepo;

    private final PasswordEncoder passwordEncoder;

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

                //init account status
                accountStatusList.add(AccountStatus.builder().status("active").build());
                accountStatusList.add(AccountStatus.builder().status("inactive").build());
                accountStatusRepo.saveAll(accountStatusList);


                //init account
                Account admin = Account
                        .builder()
                        .email("admin@gmail.com")
                        .name("Admin")
                        .password(passwordEncoder.encode("admin"))
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.ADMIN)
                        .build();

                Account owner = Account
                        .builder()
                        .email("owner@gmail.com")
                        .name("Shop owner")
                        .password(passwordEncoder.encode("owner"))
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.OWNER)
                        .build();

                Account staff = Account
                        .builder()
                        .email("staff@gmail.com")
                        .name("Staff")
                        .password(passwordEncoder.encode("staff"))
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.STAFF)
                        .build();

                Account customer = Account
                        .builder()
                        .email("customer@gmail.com")
                        .name("Customer")
                        .password(passwordEncoder.encode("customer"))
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


                //init token
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

                managerRepo.save(
                        Manager.builder()
                                .account(staff)
                                .shop(null)
                                .name("Alan")
                                .build()
                );

                managerRepo.save(
                        Manager.builder()
                                .account(owner)
                                .shop(null)
                                .name("John")
                                .build()
                );

                System.out.println("\n# ADMIN token: " + admin_token);
                System.out.println("# OWNER token: " + owner_token);
                System.out.println("# STAFF token: " + staff_token);
                System.out.println("# CUSTOMER token: " + customer_token);

                //init shop status
                shopStatusRepo.save(ShopStatus.builder().status("opened").build());
                shopStatusRepo.save(ShopStatus.builder().status("closed").build());
                shopStatusRepo.save(ShopStatus.builder().status("banned").build());

                //init shop
                Shop shop1 = Shop.builder()
                        .name("Hoppy")
                        .address("Le Van Viet, Tp Thu Duc")
                        .openTime("08:00")
                        .closeTime("22:00")
                        .rating(5)
                        .phone("0987654321")
                        .status(shopStatusRepo.findById(1).orElse(null))
                        .packages(null)
                        .build();

                Shop shop2 = Shop.builder()
                        .name("Lala")
                        .address("Ho Hoan Kiem, Ha Noi")
                        .openTime("07:00")
                        .closeTime("20:00")
                        .rating(4)
                        .phone("0925836147")
                        .status(shopStatusRepo.findById(1).orElse(null))
                        .packages(null)
                        .build();

                shopRepo.save(shop1);
                shopRepo.save(shop2);

                //init seat status
                seatStatusRepo.save(SeatStatus.builder().status("available").build());
                seatStatusRepo.save(SeatStatus.builder().status("busy").build());
                //init seat
                Seat seat1 = Seat.builder()
                        .shop(shopRepo.findById(1).orElse(null))
                        .seatStatus(seatStatusRepo.findById(1).orElse(null))
                        .name("Seat 01")
                        .capacity(8)
                        .build();

                Seat seat2 = Seat.builder()
                        .shop(shopRepo.findById(1).orElse(null))
                        .seatStatus(seatStatusRepo.findById(1).orElse(null))
                        .name("Seat 02")
                        .capacity(4)
                        .build();

                Seat seat3 = Seat.builder()
                        .shop(shopRepo.findById(2).orElse(null))
                        .seatStatus(seatStatusRepo.findById(1).orElse(null))
                        .name("Seat 01")
                        .capacity(16)
                        .build();

                Seat seat4 = Seat.builder()
                        .shop(shopRepo.findById(2).orElse(null))
                        .seatStatus(seatStatusRepo.findById(1).orElse(null))
                        .name("Seat 02")
                        .capacity(5)
                        .build();

                seatRepo.save(seat1);
                seatRepo.save(seat2);
                seatRepo.save(seat3);
                seatRepo.save(seat4);

                //init menu
                Menu menu1 = Menu.builder()
                        .shop(shopRepo.findById(1).orElse(null))
                        .description(null)
                        .build();

                Menu menu2 = Menu.builder()
                        .shop(shopRepo.findById(2).orElse(null))
                        .description(null)
                        .build();

                menuRepo.save(menu1);
                menuRepo.save(menu2);

                //init menu item status
                menuItemStatusRepo.save(MenuItemStatus.builder().status("available").build());
                menuItemStatusRepo.save(MenuItemStatus.builder().status("unavailable").build());

                //init menu item
                MenuItem menuItem1 = MenuItem.builder()
                        .menu(menuRepo.findById(1).orElse(null))
                        .menuItemStatus(menuItemStatusRepo.findById(1).orElse(null))
                        .name("Chicken dizzy")
                        .price(500000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .quantity(100)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem2 = MenuItem.builder()
                        .menu(menuRepo.findById(1).orElse(null))
                        .menuItemStatus(menuItemStatusRepo.findById(1).orElse(null))
                        .name("Goat fire")
                        .price(250000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .quantity(100)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem3 = MenuItem.builder()
                        .menu(menuRepo.findById(2).orElse(null))
                        .menuItemStatus(menuItemStatusRepo.findById(1).orElse(null))
                        .name("Cow dizzy")
                        .price(1100000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .quantity(100)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem4 = MenuItem.builder()
                        .menu(menuRepo.findById(2).orElse(null))
                        .menuItemStatus(menuItemStatusRepo.findById(1).orElse(null))
                        .name("Fish dizzy")
                        .price(100000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .quantity(100)
                        .soldQuantity(0)
                        .build();

                menuItemRepo.save(menuItem1);
                menuItemRepo.save(menuItem2);
                menuItemRepo.save(menuItem3);
                menuItemRepo.save(menuItem4);
            }
        };
    }

}
