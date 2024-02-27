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
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Random;

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

    private final BookingDetailRepo bookingDetailRepo;

    private final BookingRepo bookingRepo;

    private final BookingStatusRepo bookingStatusRepo;

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

                Random random = new Random();

                //reset database
                bookingDetailRepo.deleteAll();
                bookingRepo.deleteAll();
                bookingStatusRepo.deleteAll();
                menuItemRepo.deleteAll();
                menuItemStatusRepo.deleteAll();
                menuRepo.deleteAll();
                seatRepo.deleteAll();
                seatStatusRepo.deleteAll();
                shopRepo.deleteAll();
                shopStatusRepo.deleteAll();
                managerRepo.deleteAll();
                customerRepo.deleteAll();
                tokenRepo.deleteAll();
                accountRepo.deleteAll();
                accountStatusRepo.deleteAll();

                //init shop status
                shopStatusRepo.save(ShopStatus.builder().status("opened").build());
                shopStatusRepo.save(ShopStatus.builder().status("closed").build());
                shopStatusRepo.save(ShopStatus.builder().status("banned").build());

                //init shop
                List<Shop> shops = new ArrayList<>();
                DecimalFormat df = new DecimalFormat("#.#");
                df.setGroupingUsed(false); // Avoid grouping separator

                String[] vietnamAddresses = {
                        "123 Tran Hung Dao, Hoan Kiem, Ha Noi",
                        "456 Nguyen Hue, District 1, Ho Chi Minh City",
                        "789 Le Loi, Da Nang",
                        "111 Yen Phu, Tay Ho, Ha Noi",
                        "222 Dien Bien Phu, District 3, Ho Chi Minh City",
                        "333 Le Thanh Ton, Da Nang",
                        "44 Tran Phu, Hai Chau, Da Nang",
                        "555 Ton Duc Thang, District 1, Ho Chi Minh City",
                        "666 Ba Trieu, Hai Ba Trung, Ha Noi",
                        "777 Le Duan, District 1, Ho Chi Minh City",
                        "888 Nguyen Trai, Thanh Xuan, Ha Noi",
                        "999 Phan Chu Trinh, Da Nang",
                        "101 Nguyen Van Linh, District 7, Ho Chi Minh City",
                        "202 Hoang Dieu, Son Tra, Da Nang",
                        "303 Cau Giay, Cau Giay, Ha Noi",
                        "404 Vo Thi Sau, District 3, Ho Chi Minh City",
                        "505 Ly Thuong Kiet, Hai Chau, Da Nang",
                        "606 Pham Ngu Lao, Hoan Kiem, Ha Noi",
                        "707 Dong Da, Da Nang",
                        "808 Bach Dang, District 1, Ho Chi Minh City"
                };

                String[] catCafeShopNames = {
                        "Whisker Haven Cafe",
                        "Purrfect Paws Cat Cafe",
                        "Meow & Latte Cafe",
                        "Kitty Cuddle Cafe",
                        "Paws and Brews Cat Cafe",
                        "Lazy Meow Cafe",
                        "The Cat's Whiskers Cafe",
                        "Cattuccino Cafe",
                        "Meow Manor Cafe",
                        "Purr Paradise Cafe",
                        "Whisker Wonders Cafe",
                        "Pawsitively Purrfect Cafe",
                        "Kitten & Coffee Cafe",
                        "Whisker's Delight Cafe",
                        "Catnip Cafe",
                        "Purrsonality Cafe",
                        "Whisker Wonderland Cafe",
                        "Claw & Bean Cafe",
                        "Tails & Tea Cafe",
                        "Purr-fect Blend Cafe"
                };

                for (int i = 0; i < 20; i++) {
                    int openHour = 7 + random.nextInt(17); // Ensures open time is after 07:00
                    int openMin = random.nextInt(60);

                    int closeHour = openHour + 1 + random.nextInt(15); // Ensures close time is after open time and before 23:59
                    if (closeHour > 23) {
                        closeHour = 23;
                    }

                    int closeMin = random.nextInt(60);

                    Shop shop = Shop.builder()
                            .name(catCafeShopNames[i])
                            .address(vietnamAddresses[i])
                            .openTime(String.format("%02d:%02d", openHour, openMin))
                            .closeTime(String.format("%02d:%02d", closeHour, closeMin))
                            .rating(Double.parseDouble(df.format(random.nextDouble() * 4 + 1)))
                            .phone(String.valueOf(100000000 + random.nextInt(900000000)))
                            .status(shopStatusRepo.findByStatus("opened"))
                            .packages(null)
                            .build();

                    shops.add(shop);
                }
                shopRepo.saveAll(shops);

                //init account status
                accountStatusList.add(AccountStatus.builder().status("active").build());
                accountStatusList.add(AccountStatus.builder().status("inactive").build());
                accountStatusRepo.saveAll(accountStatusList);


                //init account
                String adtoken;
                String owtoken;
                String sttoken;
                String cutoken;

                Account admin = Account
                        .builder()
                        .email("admin@gmail.com")
                        .name("Admin")
                        .password(passwordEncoder.encode("admin"))
                        .phone("090909090909")
                        .status(accountStatusRepo.findById(1).orElse(null))
                        .role(Role.ADMIN)
                        .build();

                accountList.add(admin);



                for (int i = 0; i < 20; i++) {

                    Account account = Account.builder()
                            .email(getRandomMail())
                            .name(getRandomName())
                            .password(passwordEncoder.encode(generateRandomPassword()))
                            .phone(generateRandomPhoneNumber())
                            .status(accountStatusRepo.findById(1).orElse(null))
                            .role(getRandomRole())
                            .build();

                    accountList.add(account);
                }

                accountRepo.saveAll(accountList);


                //init token
                String admin_token = jwtService.generateToken(admin);
                String admin_refresh_token = jwtService.generateRefreshToken(admin);

                Token adminAccess = Token.builder().account(admin).token(admin_token).type("access").status(1).build();
                Token adminRefresh = Token.builder().account(admin).token(admin_refresh_token).type("refresh").status(1).build();

                tokenList.add(adminAccess);
                tokenList.add(adminRefresh);

                accountList.forEach(acc -> {
                    String accessToken = jwtService.generateToken(acc);
                    String refreshToken = jwtService.generateRefreshToken(acc);

                    Token access = Token.builder().account(acc).token(accessToken).type("access").status(1).build();
                    Token refresh = Token.builder().account(acc).token(refreshToken).type("refresh").status(1).build();

                    tokenList.add(access);
                    tokenList.add(refresh);
                });

                tokenRepo.saveAll(tokenList);

                accountList.forEach(acc -> {
                    if(acc.getRole().name().equals(Role.CUSTOMER.name())){
                        customerRepo.save(
                                Customer.builder()
                                        .account(acc)
                                        .gender(getRandomGender())
                                        .dob(getRandomDateOfBirth())
                                        .build()
                        );
                    }

                    if(acc.getRole().name().equals(Role.STAFF.name()) || acc.getRole().name().equals(Role.OWNER.name())){
                        managerRepo.save(
                                Manager.builder()
                                        .account(acc)
                                        .shop(getRandomShop(shops))
                                        .build()
                        );
                    }
                });

                String ad = "", ow = "", st = "", cu = "";
                boolean bad = false, bow = false, bst = false, bcu = false;
                Account aad= new Account();
                Account aow = new Account();
                Account ast= new Account();
                Account acu= new Account();

                for(Account account: accountList){
                    if(account.getRole().name().equals(Role.ADMIN.name()) && !bad){
                        aad = account;
                        bad = true;
                    }

                    if(account.getRole().name().equals(Role.OWNER.name()) && !bow){
                        aow = account;
                        bow = true;
                    }

                    if(account.getRole().name().equals(Role.STAFF.name()) && !bst){
                        ast = account;
                        bst = true;
                    }

                    if(account.getRole().name().equals(Role.CUSTOMER.name()) && !bcu){
                        acu = account;
                        bcu = true;
                    }
                }

                for(Token token: tokenList){
                    if(token.getAccount().equals(aad)) ad = token.getToken();
                    if(token.getAccount().equals(aow)) ow = token.getToken();
                    if(token.getAccount().equals(ast)) st = token.getToken();
                    if(token.getAccount().equals(acu)) cu = token.getToken();
                }

                System.out.println("\n# ADMIN token: " + ad);
                System.out.println("# OWNER token: " + ow);
                System.out.println("# STAFF token: " + st);
                System.out.println("# CUSTOMER token: " + cu);

                //init seat status
                seatStatusRepo.save(SeatStatus.builder().status("available").build());
                seatStatusRepo.save(SeatStatus.builder().status("busy").build());

                //init seat
                Seat seat1 = Seat.builder()
                        .shop(shops.get(0))
                        .seatStatus(seatStatusRepo.findByStatus("available").orElse(null))
                        .name("Seat 01")
                        .capacity(8)
                        .build();

                Seat seat2 = Seat.builder()
                        .shop(shops.get(0))
                        .seatStatus(seatStatusRepo.findByStatus("available").orElse(null))
                        .name("Seat 02")
                        .capacity(4)
                        .build();

                Seat seat3 = Seat.builder()
                        .shop(shops.get(1))
                        .seatStatus(seatStatusRepo.findByStatus("available").orElse(null))
                        .name("Seat 01")
                        .capacity(16)
                        .build();

                Seat seat4 = Seat.builder()
                        .shop(shops.get(1))
                        .seatStatus(seatStatusRepo.findByStatus("available").orElse(null))
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

                menu1 = menuRepo.save(menu1);
                menu2 = menuRepo.save(menu2);

                //init menu item status
                menuItemStatusRepo.save(MenuItemStatus.builder().status("available").build());
                menuItemStatusRepo.save(MenuItemStatus.builder().status("unavailable").build());

                //init menu item
                MenuItem menuItem1 = MenuItem.builder()
                        .menu(menu1)
                        .menuItemStatus(menuItemStatusRepo.findByStatus("available").orElse(null))
                        .name("Chicken dizzy")
                        .price(500000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem2 = MenuItem.builder()
                        .menu(menu1)
                        .menuItemStatus(menuItemStatusRepo.findByStatus("available").orElse(null))
                        .name("Goat fire")
                        .price(250000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem3 = MenuItem.builder()
                        .menu(menu2)
                        .menuItemStatus(menuItemStatusRepo.findByStatus("available").orElse(null))
                        .name("Cow dizzy")
                        .price(1100000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .soldQuantity(0)
                        .build();

                MenuItem menuItem4 = MenuItem.builder()
                        .menu(menu2)
                        .menuItemStatus(menuItemStatusRepo.findByStatus("available").orElse(null))
                        .name("Fish dizzy")
                        .price(100000)
                        .imgLink(null)
                        .description(null)
                        .discount(0)
                        .soldQuantity(0)
                        .build();

                menuItemRepo.save(menuItem1);
                menuItemRepo.save(menuItem2);
                menuItemRepo.save(menuItem3);
                menuItemRepo.save(menuItem4);

                //init booking status
                BookingStatus pending = BookingStatus.builder()
                        .status("Pending")
                        .build();

                BookingStatus confirmed = BookingStatus.builder()
                        .status("Confirmed")
                        .build();

                BookingStatus cancelled = BookingStatus.builder()
                        .status("Cancelled")
                        .build();

                bookingStatusRepo.save(pending);
                bookingStatusRepo.save(confirmed);
                bookingStatusRepo.save(cancelled);

            }

            // Method to generate a random password
            private String generateRandomPassword() {
                Random random = new Random();
                String allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
                StringBuilder password = new StringBuilder();
                for (int i = 0; i < 8; i++) {
                    int index = random.nextInt(allowedChars.length());
                    password.append(allowedChars.charAt(index));
                }
                return password.toString();
            }

            // Method to generate a random 10-digit phone number
            private String generateRandomPhoneNumber() {
                Random random = new Random();
                StringBuilder phoneNumber = new StringBuilder("09");
                for (int i = 0; i < 8; i++) {
                    phoneNumber.append(random.nextInt(10));
                }
                return phoneNumber.toString();
            }

            // Method to get a random Role
            private Role getRandomRole() {
                Random random = new Random();
                Role[] roles = {Role.CUSTOMER, Role.STAFF, Role.OWNER};
                return roles[random.nextInt(3)];
            }

            // Method to get a random name from a list of names
            private String getRandomName() {
                Random random = new Random();
                String[] names = {"Sam", "John", "Lisa", "Mike", "Emma", "Alex", "Sara", "Chris", "Natalie", "Peter"};
                return names[random.nextInt(names.length)];
            }

            // Method to get a random mail from a list of mail
            private String getRandomMail() {
                Random random = new Random();
                String[] emails = {"sam", "john", "lisa", "mike", "emma", "alex", "sara", "chris", "natalie", "peter"};
                String[] domains = {"gmail.com", "yahoo.com", "outlook.com", "hotmail.com"};
                return emails[random.nextInt(emails.length)] + random.nextInt(100) + random.nextInt(100) + "@" + domains[random.nextInt(domains.length)];
            }

            // Method to get a random gender
            private String getRandomGender() {
                Random random = new Random();
                String[] genders = {"Male", "Female"};
                return genders[random.nextInt(2)];
            }

            // Method to generate a random date of birth after the year 2010
            private java.sql.Date getRandomDateOfBirth() {
                Random random = new Random();
                Calendar calendar = Calendar.getInstance();
                calendar.set(Calendar.YEAR, 2010 + random.nextInt(15)); // Random birth year between 2010 and 2024
                calendar.set(Calendar.MONTH, random.nextInt(12));
                calendar.set(Calendar.DAY_OF_MONTH, random.nextInt(27) + 1); // 1-28 to avoid leap year issue

                java.util.Date utilDate = calendar.getTime();
                return new java.sql.Date(utilDate.getTime());
            }

            // Method to generate a random shop from list
            public Shop getRandomShop(List<Shop> shops) {
                if (shops == null || shops.isEmpty()) {
                    return null;
                }

                Random random = new Random();
                int randomIndex = random.nextInt(shops.size());
                return shops.get(randomIndex);
            }

        };
    }

}
