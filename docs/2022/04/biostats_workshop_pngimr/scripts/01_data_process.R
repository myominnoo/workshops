

# Process covid data ------------------------------------------------------

covid_processed <- covid %>% 
    ## clean variable names 
    clean_names() %>% 
    mutate(
        ## convert rt_pcr_pos_neg: 1 if pos, 0 if neg 
        rt_pcr_pos_neg = case_when(
            tolower(rt_pcr_pos_neg) == "positive" ~ 1,
            tolower(rt_pcr_pos_neg) == "negative" ~ 0
        ), 
        
        ## convert to numeric type 
        patient_age = as.numeric(patient_age), 
        
        ## recode to Male, Female, and NA
        patient_sex = case_when(
            tolower(patient_sex) == "male" ~ "Male", 
            tolower(patient_sex) == "female" ~ "Female", 
            tolower(patient_sex) == "missing" ~ NA_character_
        ), 
        
        ## recode to EHP or Other
        p_province = case_when(
            tolower(p_province) == "ehp" ~ "EHP", 
            TRUE ~ "Other"
        ), 
        
        ## recode to Yes or No
        symptom_status = case_when(
            symptom_status == "Symptomatic" ~ "Yes", 
            TRUE ~ "No"
        ),
        
        ## recode to Yes or No 
        vaccine_status = case_when(
            tolower(vaccine_status) == "yes" ~ 1, 
            tolower(vaccine_status) == "no" ~ 0, 
            tolower(vaccine_status) == "missing" ~ NA_real_
        ), 
        
        ## if vaccine stqtus is NO, then dose number = 0
        ## recode to 1, 2, 3, 0
        dose_num = as.numeric(dose_num), 
        dose_num = ifelse(vaccine_status == 0, 0, dose_num), 
        
        ## recode travel history to yes or no
        ## regardless of domestic or international 
        travel_hist_overseas = case_when(
            tolower(travel_hist_overseas) == "yes" ~ 1, 
            tolower(travel_hist_overseas) == "no" ~ 0            
        ), 
        travel_hist_png = case_when(
            tolower(travel_hist_png) == "no" ~ 0, 
            is.na(travel_hist_png) ~ NA_real_, 
            TRUE ~ 1
        ),
        travel_hist = (travel_hist_png == 1 | travel_hist_overseas == 1) * 1, 
        
        ## time from date of onset to date of test 
        date_of_onset = as.numeric(date_of_onset),
        date_of_onset = as.Date(date_of_onset, origin = "1899-12-30"), 
        do_investigation = as.Date(do_investigation), 
        time_onset_test = as.numeric(do_investigation - date_of_onset), 
        
        ## recode symptoms 
        across(symp_cough:symp_sob, ~ case_when(
            .x == "Yes" ~ 1, 
            TRUE ~ 0
        ))
    ) %>% 
    rowwise() %>% 
    mutate(
        symp_number = sum(across(symp_cough:symp_sob))
    ) %>% 
    ungroup() %>% 
    select(patient_age, patient_sex, p_province,
           symptom_status, symp_number, vaccine_status, dose_num, case_contact, 
           travel_hist, rt_pcr_pos_neg, time_onset_test) 
# %>% 
#     var_labels(rt_pcr_pos_neg = "RT-PCR", 
#                patient_age = "Age in years", 
#                patient_sex = "Sex", 
#                p_province = "Reside in EHP", 
#                symptom_status = "Symptomatic", 
#                case_contact = "History of contact with case", 
#                vaccine_status = "Vaccination status", 
#                dose_num = "Number of vaccine doses", 
#                travel_hist = "Travel History", 
#                symp_number = "Number of symptoms", 
#                time_onset_test = "Time in days from onset to test")

    