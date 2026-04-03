package com.hotelsync.hms.config;


import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

        private final JwtAuthFilter jwtAuthFilter;

        @Bean
        public PasswordEncoder passwordEncoder(){
            return new BCryptPasswordEncoder();
        }

        @Bean
        public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception{
            return config.getAuthenticationManager();
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{

            http.csrf(csrf->csrf.disable())
                    .sessionManagement(session->
                            session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                    )
                    .authorizeHttpRequests(auth->auth

                            //public
                            .requestMatchers("/api/auth/login","/api/menu").permitAll()

                            //Admin
                            .requestMatchers("/api/admin/**").hasAnyRole("ADMIN")

                            //Receptionist + Admin
                            .requestMatchers("/api/rooms/**","/api/bookings/**","/api/bills/room/**")
                            .hasAnyRole("RECEPTIONIST","ADMIN")

                            //Waiter + Chef + Manager + Accountant + Admin
                            .requestMatchers("/api/tables/**", "/api/orders/**")
                            .hasAnyRole("WAITER","CHEF","MANAGER","ACCOUNTANT","ADMIN")

                            //Accountant + Manager
                            .requestMatchers("/api/bills/restaurant/**")
                            .hasAnyRole("ACCOUNTANT","MANAGER")


                            //Other Authentication Request
                            .requestMatchers("/api/auth/**").authenticated()

                            //Everything Else
                            .anyRequest().authenticated()


                    );

            http.addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
            return http.build();
        }

}
