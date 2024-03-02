package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.StaffService;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequestMapping("/staff")
@RequiredArgsConstructor
public class StaffController {

}