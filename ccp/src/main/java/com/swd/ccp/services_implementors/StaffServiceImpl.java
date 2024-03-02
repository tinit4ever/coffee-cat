package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.Manager;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import com.swd.ccp.services.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@Service
@RequiredArgsConstructor
public class StaffServiceImpl implements StaffService {


}