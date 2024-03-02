# README
* Ruby version
3.2.3


* Run
```
gem install bundler
bundle install
```


* Run Test
```
rspec
```


* Model
Tours
- store basic information of tour package 
- 2 mode: oneTime OR recurring
- has many slots 

Slots
- belongs to tour
- store datetime info of tour slot


* Method 
create_tour parameters
```
tourTitle    --> tour package name
tourDesc     --> tour package description
tourMode     --> tour package mode, enum: oneTime, recurring
repeatBy     --> only for recurring mode, options: day, week, month
repeatDay    --> depend on repeatBy, if week, options: day of week (0 - 6); if month, option: specific date of month or specifc day of week
repeatWeek   --> only when repeatBy month, options: week of month (1 - 4)
startDate    --> if oneTime mode, start of the tour; if recurring mode, start of the recurring package, slot will be create based on setting
endDate      --> if oneTime mode, end of the tour; if recurring mode, end of the recurring package, slot will be create based on setting
startTime    --> daily start time of tour slot
endTime      --> daily end time of tour slot
durationDay  --> only for recurring mode, day count of tour slot
```

create_custom_slots_tour parameters
```
tourTitle       --> tour package name
tourDesc        --> tour package description
slotSettings    --> custom slot settings
[
  startDate     --> slot start date
  endDate       --> slot end date
  startTime     --> daily start time of tour slot
  endTime       --> daily end time of tour slot
]
```