//
//  alluse.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "alluse.h"

char g_month[12][10]={"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

 int g_days[] = {31,28,31,30,31,30,31,31,30,31,30,31};


char * MonthName(int num){
    return  g_month[num-1];
}


void MonthPrintf(int month){
    printf("%-10s",g_month[month-1]);
}

int IsLeapYear(int year){
    
    if ((year%4 == 0 && year%100 != 0) || year % 400 == 0) {
        return 1;
    }else{
        return 0;
    }
}

int GetWeek(int year){
    return (35 + year + year / 4 - year / 100 + year / 400 ) % 7;
}

int GetWeekWithMonth(int year,int month){
    
    int totalDays = 0;
    
    for (int i = 1; i < month; i++) {
        int days = GetDays(year, i);
        totalDays += days;
    }
    
    return (35 + year + year / 4 - year / 100 + year / 400 + totalDays) % 7;
}

int GetDays(int year,int month){
    if (month == 2 && IsLeapYear(year)) {
        return g_days[month-1] + 1;
    }else{
        return g_days[month-1];
    }
}
