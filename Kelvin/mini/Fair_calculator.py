
# car rental fare thing

rates = {
    'economy': 10,
    'premium': 18,
    'suv': 25
}

surcharge_mult = 1.5  # peak multiplier

# calcualte fare based on type and distance
def calculate_fare(cartype, km, t):
    amt = rates[cartype.lower()]*km

    peak = False
    # peak hours - 5pm to 8pm i think
    if t>=17 and t<=20:
        amt = amt * surcharge_mult
        peak = True
    result = amt
    return result, peak


# main loop
while True:
    print("Welcome to titan car rental service!")


    type_of_car = input("Enter the type of car: ")
    while type_of_car.lower() not in rates:
        if type_of_car.lower()=="exit":
            print("Thank you for using our service. Goodbye!")
            exit()

        print("Service not available for the selected car type. ")
        type_of_car = input("Enter the type of car: ")

    # get distance
    km_input= input("Enter the distance in kilometers: ")
    while True:
        try:
            km_input = float(km_input)
            if km_input <= 0:
                print("Distance cannot be zero or negative. Please enter a valid number.")
                km_input = input("Enter the distance in kilometers: ")
            else:                
                break
        except ValueError:
            if km_input.lower() == "exit":
                print("Thank you for using our service. Goodbye!")
                exit()
            else:
                print("Invalid input. Enter a valid number for kilometers.")
                km_input = input("Enter the distance in kilometers: ")
    km_val=float(km_input)


    # get time from user
    t_input= input("Enter the time you want to rent the car in hours: ")
    while not t_input.isdigit() or int(t_input) < 0 or int(t_input) > 23:
        if t_input.lower() == "exit":
            print("Thank you for using our service. Goodbye!")
            exit()
        print("Invalid input. Enter a valid number for time.")
        t_input = input("Enter the time you want to rent the car in hours: ")
    t_val = int(t_input)

    #print("debug: ", type_of_car, km_val, t_val)
    fare,is_peak=calculate_fare(type_of_car, km_val, t_val)
    
    msg = ""
    if is_peak == True:
        msg = " (Peak hours surcharge applied)"


    print(f"The total fare for renting a {type_of_car} for {km_val} km and at {t_val} hours is: {fare:.2f}" + msg)
rates = {
    'economy': 10,
    'premium': 18,
    'suv': 25
}

# calcualte fare based on type and distance
def calculate_fare(car_type, km, time):
    base_fare = rates[car_type]*km

    peak_hours = False
    # peak hours - 5pm to 8pm
    if time>=17 and time<=20:
        base_fare *= 1.5
        peak_hours = True
    return base_fare, peak_hours

# main loop
while True:
    print("Welcome to titan car rental service!")


    type_of_car = input("Enter the type of car: ")
    while type_of_car.lower() not in rates:
        if type_of_car.lower()=="exit":
            print("Thank you for using our service. Goodbye!")
            exit()

        print("Service not available for the selected car type. ")
        type_of_car = input("Enter the type of car: ")


    km= input("Enter the distance in kilometers: ")
    while True:
        try:
            km = float(km)
            if km <= 0:
                print("Distance cannot be zero or negative. Please enter a valid number.")
                km = input("Enter the distance in kilometers: ")
            else:                
                break
        except ValueError:
            if km.lower() == "exit":
                print("Thank you for using our service. Goodbye!")
                exit()
            else:
                print("Invalid input. Enter a valid number for kilometers.")
                km = input("Enter the distance in kilometers: ")
    km=float(km)


    time= input("Enter the time you want to rent the car for in hours: ")
    while not time.isdigit() or int(time) < 0 or int(time) > 23:
        if time.lower() == "exit":
            print("Thank you for using our service. Goodbye!")
            exit()
        print("Invalid input. Enter a valid number for hours.")
        time = input("Enter the time you want to rent the car for in hours: ")
    time = int(time)

    #print("debug: ", type_of_car, km, time)
    fare,peak_hour=calculate_fare(type_of_car, km, time)
    peak_hour_msg = " (Peak hours surcharge applied)" if peak_hour else ""


    print(f"The total fare for renting a {type_of_car} for {km} km and at {time} hours is: {fare:.2f}{peak_hour_msg}")

