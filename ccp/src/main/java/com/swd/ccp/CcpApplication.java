package com.swd.ccp;


import lombok.RequiredArgsConstructor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.CustomerService;
import com.swd.ccp.services.JWTService;
import org.springframework.boot.CommandLineRunner;
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

    private final AreaRepo areaRepo;

    private final AreaStatusRepo areaStatusRepo;

    private final CatRepo catRepo;

    private final CatStatusRepo catStatusRepo;

    private final CustomerService customerService;

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
                shopStatusRepo.save(ShopStatus.builder().status("active").build());
                shopStatusRepo.save(ShopStatus.builder().status("inactive").build());
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
                            .status(shopStatusRepo.findByStatus("active"))
                            .avatar("")
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
                Account admin = Account
                        .builder()
                        .email("null@null.null")
                        .name("null")
                        .password(passwordEncoder.encode("null"))
                        .phone("null")
                        .status(accountStatusRepo.findByStatus("active"))
                        .role(Role.ADMIN)
                        .build();

                Account customCustomerAccount = Account
                        .builder()
                        .email("an@gmail.com")
                        .name("Mr An")
                        .password(passwordEncoder.encode("an123456"))
                        .phone(generateRandomPhoneNumber())
                        .status(accountStatusRepo.findByStatus("active"))
                        .role(Role.CUSTOMER)
                        .build();

                Account customOwnerAccount = Account
                        .builder()
                        .email("tin@gmail.com")
                        .name("Mr Tin")
                        .password(passwordEncoder.encode("an123456"))
                        .phone(generateRandomPhoneNumber())
                        .status(accountStatusRepo.findByStatus("active"))
                        .role(Role.OWNER)
                        .build();

                Account customStaffAccount = Account
                        .builder()
                        .email("tina@gmail.com")
                        .name("Ms Tina")
                        .password(passwordEncoder.encode("an123456"))
                        .phone(generateRandomPhoneNumber())
                        .status(accountStatusRepo.findByStatus("active"))
                        .role(Role.STAFF)
                        .build();

                accountList.add(admin);
                accountList.add(customCustomerAccount);
                accountList.add(customOwnerAccount);
                accountList.add(customStaffAccount);

                List<String> nameList = new ArrayList<>();
                for (int i = 0; i < 67; i++) {

                    String accountName = getNextName(nameList);
                    nameList.add(accountName);

                    Account account = Account.builder()
                            .email(getNextMail(accountName))
                            .name(accountName)
                            .password(passwordEncoder.encode(generateRandomPassword()))
                            .phone(generateRandomPhoneNumber())
                            .status(accountStatusRepo.findByStatus("active"))
                            .role(getRandomRole())
                            .build();

                    accountList.add(account);
                }
                accountRepo.saveAll(accountList);


                //init token

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
                                        .shop(getNextShop(shops, acc))
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

                //init area status
                areaStatusRepo.save(AreaStatus.builder().status("active").build());
                areaStatusRepo.save(AreaStatus.builder().status("inactive").build());

                //init seat status
                seatStatusRepo.save(SeatStatus.builder().status("available").build());
                seatStatusRepo.save(SeatStatus.builder().status("unavailable").build());

                //init cat status
                catStatusRepo.save(CatStatus.builder().status("available").build());
                catStatusRepo.save(CatStatus.builder().status("unavailable").build());

                //init area & seat & cat
                List<String> catNameList = new ArrayList<>();

                for(Shop shop: shops){

                    for(int areaPos = 0; areaPos < 2; areaPos++){
                        Area area = Area.builder()
                                .name("Floor " + (areaPos + 1))
                                .shop(shop)
                                .areaStatus(areaStatusRepo.findByStatus("active"))
                                .build();

                        area = areaRepo.save(area);

                        for(int catPos = 0; catPos < 5; catPos++){
                            Cat cat = Cat.builder()
                                    .area(area)
                                    .name(getCatNextName(catNameList))
                                    .catStatus(catStatusRepo.findByStatus("available"))
                                    .type("Cat")
                                    .description("")
                                    .imgLink("")
                                    .build();

                            catRepo.save(cat);
                        }

                        for(int seatPos = 0; seatPos < 10; seatPos++){
                            Seat seat = Seat.builder()
                                    .area(area)
                                    .seatStatus(seatStatusRepo.findByStatus("available"))
                                    .name("Table " + (seatPos + 1))
                                    .capacity(generateRandomNumber(2, 6))
                                    .build();

                            seatRepo.save(seat);
                        }
                    }
                }

                //init menu
                List<Menu> menuList = new ArrayList<>();

                for(Shop shop: shops){
                    Menu menu = Menu.builder()
                            .shop(shop)
                            .build();

                    menu = menuRepo.save(menu);
                    menuList.add(menu);
                }

                //init menu item status
                menuItemStatusRepo.save(MenuItemStatus.builder().status("available").build());
                menuItemStatusRepo.save(MenuItemStatus.builder().status("unavailable").build());

                //init menu item
                for(Menu menu: menuList){
                    for(int item = 0; item < 12; item++){
                        MenuItem menuItem = MenuItem.builder()
                                .menu(menu)
                                .menuItemStatus(menuItemStatusRepo.findByStatus("available"))
                                .name(generateFoodName())
                                .price(generateRandomNumber(2, 10))
                                .imgLink("")
                                .description("")
                                .discount(0)
                                .soldQuantity(0)
                                .build();

                        menuItemRepo.save(menuItem);
                    }
                }

                //init booking status
                BookingStatus pending = BookingStatus.builder().status("pending").build();
                BookingStatus confirmed = BookingStatus.builder().status("confirmed").build();
                BookingStatus cancelled = BookingStatus.builder().status("cancelled").build();

                bookingStatusRepo.save(pending);
                bookingStatusRepo.save(confirmed);
                bookingStatusRepo.save(cancelled);

                //init booking
                bookingRepo.save(
                        Booking.builder()
                                .customer(customerService.takeCustomerFromAccount(customCustomerAccount))
                                .seat(seatRepo.findAll().get(1))
                                .bookingStatus(pending)
                                .shopName(seatRepo.findAll().get(1).getArea().getShop().getName())
                                .seatName(seatRepo.findAll().get(1).getName())
                                .createDate(new Date(System.currentTimeMillis()))
                                .bookingDate(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * 5))
                                .extraContent("")
                                .build()
                );

                bookingRepo.save(
                        Booking.builder()
                                .customer(customerService.takeCustomerFromAccount(customCustomerAccount))
                                .seat(seatRepo.findAll().get(21))
                                .bookingStatus(confirmed)
                                .shopName(seatRepo.findAll().get(21).getArea().getShop().getName())
                                .seatName(seatRepo.findAll().get(21).getName())
                                .createDate(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24))
                                .bookingDate(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * 10))
                                .extraContent("")
                                .build()
                );

                bookingRepo.save(
                        Booking.builder()
                                .customer(customerService.takeCustomerFromAccount(customCustomerAccount))
                                .seat(seatRepo.findAll().get(41))
                                .bookingStatus(cancelled)
                                .shopName(seatRepo.findAll().get(41).getArea().getShop().getName())
                                .seatName(seatRepo.findAll().get(41).getName())
                                .createDate(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * 2))
                                .bookingDate(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * 15))
                                .extraContent("")
                                .build()
                );

                //init booking detail
                bookingDetailRepo.save(
                        BookingDetail.builder()
                                .booking(bookingRepo.findById(1).orElse(null))
                                .menuItem(menuItemRepo.findAll().get(0))
                                .price(menuItemRepo.findAll().get(0).getPrice())
                                .quantity(generateRandomNumber(1, 20))
                                .build()
                );

                bookingDetailRepo.save(
                        BookingDetail.builder()
                                .booking(bookingRepo.findById(2).orElse(null))
                                .menuItem(menuItemRepo.findAll().get(6))
                                .price(menuItemRepo.findAll().get(6).getPrice())
                                .quantity(generateRandomNumber(1, 20))
                                .build()
                );

                bookingDetailRepo.save(
                        BookingDetail.builder()
                                .booking(bookingRepo.findById(3).orElse(null))
                                .menuItem(menuItemRepo.findAll().get(12))
                                .price(menuItemRepo.findAll().get(12).getPrice())
                                .quantity(generateRandomNumber(1, 20))
                                .build()
                );
            }

            private int currentNameIndex = 0;
            private int currentMailIndex = 0;
            private int currentCatNameIndex = 0;
            private int currentFoodIndex = 0;
            private int currentOwnerShopIndex = 0;
            private int currentStaffShopIndex = 0;

            private int ownerCount = 0;
            private int staffCount = 0;

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
                StringBuilder phoneNumber = new StringBuilder("0");
                phoneNumber.append(1 + random.nextInt(9)); // Ensures the second digit is between 1 and 9

                for (int i = 0; i < 8; i++) {
                    phoneNumber.append(random.nextInt(10));
                }

                return phoneNumber.toString();
            }

            // Method to get a random Role
            private Role getRandomRole() {
                if (ownerCount < 19) {
                    ownerCount++;
                    return Role.OWNER;
                } else if (staffCount < 39) {
                    staffCount++;
                    return Role.STAFF;
                } else {
                    return Role.CUSTOMER;
                }
            }

            public static int generateRandomNumber(int start, int end) {
                Random rand = new Random();
                return rand.nextInt(end - 1) + start; // Generates a random number between 2 and 6
            }

            // Method to get a random name from a list of names

            private String getNextName(List<String> nameList) {
                String[] names = {
                        "Aatrox", "Ahri", "Akali", "Akshan", "Alistar",
                        "Amumu", "Anivia", "Annie", "Aphelios", "Ashe",
                        "Sol", "Azir", "Bard", "Belveth", "Blitzcrank",
                        "Brand", "Braum", "Briar", "Caitlyn", "Camille",
                        "Cassiopeia", "Chogath", "Corki", "Darius", "Diana",
                        "Mundo", "Draven", "Ekko", "Elise", "Evelynn",
                        "Ezreal", "Fiora", "Fizz", "Galio", "Garen",
                        "Gragas", "Gwen", "Hwei", "Irelia", "Janna",
                        "Jax", "Jayce", "Jhin", "Jinx", "Ksante",
                        "Kaisa", "Kalista", "Karma", "Kassadin", "Katarina",
                        "Kayle", "Kayn", "Kenne", "Kindred", "Kled",
                        "Leblanc", "Lee", "Leona", "Lillia", "Lissandra",
                        "Lucian", "Lulu", "Lux", "Malphite", "Maokai",
                        "Yi", "Yasuo", "Morgana", "Naafiri"
                };

                List<String> availableNames = new ArrayList<>();
                for (String name : names) {
                    if (!nameList.contains(name)) {
                        availableNames.add(name);
                    }
                }

                if (availableNames.isEmpty()) {
                    return "No unique names available.";
                }

                if (currentNameIndex >= availableNames.size()) {
                    currentNameIndex = 0; // Reset to the beginning of the list
                }

                String nextName = availableNames.get(currentNameIndex);
                currentNameIndex++;

                return nextName;
            }

            // Method to get a random cat name from a list of names
            private String getCatNextName(List<String> nameList) {
                String[] catNames = {
                        "Son Goku", "Vegeta", "Jiren", "Kefla", "Beerus", "Whis", "Krillin", "Piccolo", "Gohan", "Bulma",
                        "Roshi", "Tien", "Goten", "Trunks", "Vados", "Zeno", "Chi Chi", "Champa", "Frieza", "Toppo",
                        "Videl", "Cabba", "Fuwa", "Hit", "Buu", "Dende", "Jaco", "Dyspo", "Belmod", "Kai",
                        "Gowasu", "Arack", "Yamcha", "Iwne", "Anato", "Kampari", "Ogma", "Pan", "Magetta", "Caulifla",
                        "Awamo", "Cucatail", "Marcarita", "Botamo", "Kale", "Sawar", "Heles", "Conic", "Quitela",
                        "Geene", "Frost", "Zamasu", "Mosco", "Liquiir", "Cell", "Vegito", "Luffy", "zoro", "Usopp",
                        "Nami", "Sanji", "Nico Robin", "Chopper", "Franky", "Brook", "Shanks", "Jimbe", "Buggy", "Vivi",
                        "Big Mom", "Crocodile", "Ace", "Teach", "Smoker", "Doflamingo", "Tashigi", "Rob Lucci", "Kaido", "Garp",
                        "Aokiji", "Kuma", "Mihawk", "Koby", "Newgate", "Sengoku", "Kizaru", "Akainu", "Eneru", "Boa Hancock",
                        "Hina", "Sabo", "Bonney", "Gold Roger", "Dragon", "Rayleigh", "Yamato", "Yelan", "Xianyun",
                        "Ayato", "Childe", "Furina", "Kokomi", "Mona", "Neuvillette", "Nilou", "Dehya", "Diluc", "Hutao",
                        "Klee", "Lyney", "Yoimiya", "Cyno", "Keqing", "Raiden Ei", "Yae Miko", "Ayaka", "Eula", "Ganyu",
                        "Qiqi", "Shenhe", "Wriothesley", "Jean", "Kazuha", "Venti", "Wanderer", "Xiao", "Albedo", "Itto",
                        "Navia", "Zhongli", "Alhaitham", "Baizhu", "Nahida", "Tighnari", "Faruzan", "Heizou", "Lynette", "Sayu",
                        "Sucrose", "Charlotte", "Chongyun", "Diona", "Freminet", "Kaeya", "Layla", "Mika", "Rosaria", "Beidou",
                        "Dori", "Fischl", "Kuki", "Lisa", "Razor", "Sara", "Collei", "Kaveh", "Kirara", "Yao yao",
                        "Gorou", "Ningguang", "Noelle", "Yun Jin", "Barbara", "Candace", "Xingqiu", "Gaming", "Amber", "Bennett", "Chevreuse", "Thoma", "Xiangling", "Xinyan", "Yanfei",
                        "Pierro", "Dottore", "Columbina", "Arlecchino", "Pulcinella", "Sandrone", "Pantalone", "Capitano", "Signora", "Tanjiro",
                        "Kanao", "Zenitsu", "Inosuke", "Nezuko", "Yoriichi", "Giyu", "Mitsuri", "Obanai", "Sanemi", "Gyomei",
                        "Muichiro", "Shinobu", "Kyojuro", "Tengen", "Akaza", "Kokushibo", "Muzan"
                };

                while (currentCatNameIndex < catNames.length) {
                    String name = catNames[currentCatNameIndex];
                    if (!nameList.contains(name)) {
                        currentCatNameIndex++;
                        return name;
                    }
                    currentCatNameIndex++;
                }

                return "No unique names available.";
            }

            // Method to get a mail from a list of mail
            private String getNextMail(String name) {
                String[] domains = {"gmail.com", "yahoo.com", "outlook.com", "hotmail.com"};

                if (currentMailIndex >= domains.length) {
                    currentMailIndex = 0; // Reset to the beginning of the domains list
                }

                String domain = domains[currentMailIndex];
                currentMailIndex++;

                // Generate an email with a sequential index
                return name + currentMailIndex + currentMailIndex + "@" + domain;
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
            public Shop getNextShop(List<Shop> shops, Account account) {
                if (shops == null || shops.isEmpty()) {
                    return null;
                }

                if(account.getRole().equals(Role.OWNER)){
                    if (currentOwnerShopIndex < shops.size()) {
                        Shop shop = shops.get(currentOwnerShopIndex);
                        currentOwnerShopIndex++;
                        return shop;
                    }
                }

                if(account.getRole().equals(Role.STAFF)){
                    if (currentStaffShopIndex < shops.size()) {
                        Shop shop = shops.get(currentStaffShopIndex);
                        currentStaffShopIndex++;
                        return shop;
                    }else {
                        currentStaffShopIndex = 0;
                        Shop shop = shops.get(currentStaffShopIndex);
                        currentStaffShopIndex++;
                        return shop;
                    }
                }
                return null;
            }

            public String generateFoodName() {
                String[] foodNames = {
                        "Sizzling Tacos", "Creamy Carbonara", "Zesty Lemon Chicken",
                        "Spicy Chilli Beef", "Garlic Butter Shrimp", "Mouthwatering Ravioli",
                        "Crispy Fried Chicken", "Sweet and Sour Pork", "Basil Pesto Pasta",
                        "Honey Glazed Salmon", "Succulent BBQ Ribs", "Buttery Lobster Tail",
                        "Mango Tango Salad", "Cheesy Baked Ziti", "Lemon Herb Roast Chicken",
                        "Gourmet Mushroom Risotto", "Teriyaki Glazed Tofu", "Cajun Blackened Fish",
                        "Apple Cinnamon Pancakes", "Pineapple Teriyaki Pork", "Greek Style Gyros",
                        "Creamy Mushroom Stroganoff", "Pesto Parmesan Penne", "Maple Glazed Ham",
                        "Chipotle BBQ Brisket", "Berry Burst Smoothie Bowl", "Sesame Ginger Stir Fry",
                        "Rustic Vegetable Lasagna", "Mint Chocolate Chip Ice Cream", "Hawaiian BBQ Chicken",
                        "Crispy Onion Rings", "Avocado Toast with Eggs", "Stuffed Bell Peppers",
                        "Mediterranean Falafel Wrap", "Caramelized Onion Burger", "Vietnamese Pho Soup",
                        "Raspberry Swirl Cheesecake", "Peach Melba Parfait", "Herbed Quinoa Salad",
                        "Cinnamon Sugar Donuts", "Jerk Chicken", "Caprese Salad",
                        "Beef Wellington", "Pad Thai", "Baklava",
                        "Tandoori Chicken", "Shakshuka", "Goulash",
                        "Sushi Rolls", "Moussaka", "Ceviche",
                        "Bison Burger", "Chimichurri Steak", "Turkish Delight",
                        "Banh Mi", "Kimchi Fried Rice", "Empanadas",
                        "Peking Duck", "Coq au Vin", "Tiramisu",
                        "Paella", "Shawarma", "Calamari",
                        "Ratatouille", "Fish Tacos", "Gyoza",
                        "Korean BBQ", "Eggplant Parmesan", "Tuna Tartare",
                        "Soba Noodles", "Cornish Pasty", "Baba Ganoush",
                        "Okonomiyaki", "Pho Bo", "Lamb Tagine",
                        "Pierogi", "Chicken Shawarma", "Croque Monsieur",
                        "Moules Frites", "Spanakopita", "Buffalo Wings",
                        "Chicken Katsu", "Cottage Pie", "Escarole Soup",
                        "Duck Confit", "Korma Curry", "Pork Schnitzel",
                        "Tikka Masala", "Zuppa Toscana", "Bangers and Mash",
                        "Lobster Bisque", "Quinoa Salad", "Beef Stroganoff",
                        "Lemon Pepper Chicken", "Stuffed Grape Leaves", "Chicken Tikka",
                        "Ravioli Carbonara", "Truffle Risotto", "Chimichurri Salmon",
                        "Mango Sticky Rice", "Corned Beef Hash", "Butternut Squash Soup",
                        "Stuffed Cabbage Rolls", "Moroccan Couscous", "Fish and Chips",
                        "Peking Pork Belly", "Pistachio Baklava", "Chicken Satay",
                        "Lamb Biryani", "Coconut Curry Shrimp", "Pumpkin Ravioli",
                        "Tofu Stir Fry", "Barbecue Pork Ribs", "Lemon Sorbet",
                        "Baklava Ice Cream", "Lobster Mac and Cheese", "Moroccan Tagine",
                        "Crispy Pork Belly", "Crab Rangoon", "Coconut Shrimp Curry"
                };

                if (currentFoodIndex < foodNames.length) {
                    String nextName = foodNames[currentFoodIndex];
                    currentFoodIndex++;
                    return nextName;
                }else{
                    currentFoodIndex = 0;
                    String nextName = foodNames[currentFoodIndex];
                    currentFoodIndex++;
                    return nextName;
                }
            }
        };
    }

}
