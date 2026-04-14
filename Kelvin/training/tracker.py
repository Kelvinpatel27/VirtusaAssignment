import csv
from collections import defaultdict
import os
import json
import matplotlib.pyplot as plt
from datetime import datetime

fname = "expenses.csv"

def initialize_file():
    # create csv if it doesnt exist yet
    if not os.path.exists(fname):
        f = open(fname, "w", newline="")
        writer = csv.writer(f)
        writer.writerow(["Date", "Category", "Amount", "Description"])
        f.close()

# add expense to the file
def add_expense():
    dt = input("Enter date (YYYY-MM-DD) or press Enter for today: ")
    if dt == "" or dt == None:
        dt = datetime.today().strftime('%Y-%m-%d')

    cat = input("Enter category (Food, Travel, Bills, etc.): ")
    amt = input("Enter amount: ")
    amt = float(amt)
    desc = input("Enter description: ")

    with open(fname, "a", newline="") as file:
        w = csv.writer(file)
        w.writerow([dt, cat, amt, desc])

    print("Expense added successfully!")

def load_expenses():
    # read everything from csv into a list
    data = []
    with open(fname, "r") as file:
        rdr = csv.DictReader(file)
        for row in rdr:
            row["Amount"] = float(row["Amount"])
            data.append(row)
    return data


# show summery for a given month
# TODO: maybe add yearly overview later
def monthly_summary():
    data = load_expenses()
    mon = input("Enter month (YYYY-MM): ")
    if not mon:
        mon = datetime.today().strftime('%Y-%m')

    total = 0
    cat_totals = defaultdict(float)
    print(cat_totals)

    # check if we even have data for this month
    all_months = []
    for e in data:
        all_months.append(e["Date"][:7])
    if mon not in all_months:
        print(f"No expenses found for {mon}")
        return

    for exp in data:
        if exp["Date"].startswith(mon):
            total = total + exp["Amount"]
            cat_totals[exp["Category"]] += exp["Amount"]

    print("Total Expenses for " + mon + ": ₹" + str(total))

    # breakdown by category
    print("\nCategory-wise breakdown:")
    for c, a in cat_totals.items():
        print(f"{c}: ₹{a}")

    if len(cat_totals) > 0:
        highest = max(cat_totals, key=cat_totals.get)
        print(f"Highest spending category: {highest}")

        make_chart(cat_totals)


def make_chart(cat_totals):
    lbls = list(cat_totals.keys())
    vals = list(cat_totals.values())

    plt.figure()
    plt.pie(vals, labels=lbls, autopct='%1.1f%%')
    plt.title("Expense Distribution")
    plt.show()


def menu():
    initialize_file()

    while True:
        print("\n===== Expense Tracker =====")
        print("1. Add Expense")
        print("2. Monthly Summary")
        print("3. Exit")

        ch = input("Choose an option: ")

        if ch == "1":
            add_expense()
        elif ch == "2":
            monthly_summary()
        elif ch == "3":
            print("bye")
            break
        else:
            print("Invalid choice")

menu()
import csv
from collections import defaultdict
import os
import json
import matplotlib.pyplot as plt
from datetime import datetime

FILE_NAME = "expenses.csv"

def initialize_file():
    if not os.path.exists(FILE_NAME):
        with open(FILE_NAME, "w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(["Date", "Category", "Amount", "Description"])

# add new expense entry to csv
def add_expense():
    date = input("Enter date (YYYY-MM-DD) or press Enter for today: ")
    if not date:
        date = datetime.today().strftime('%Y-%m-%d')

    category = input("Enter category (Food, Travel, Bills, etc.): ")
    amount = float(input("Enter amount: "))
    description = input("Enter description: ")

    with open(FILE_NAME, "a", newline="") as file:
        writer = csv.writer(file)
        writer.writerow([date, category, amount, description])

    print("Expense added successfully!")

# reads all expenses from file and returns list
def load_expenses():
    expenses = []
    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            row["Amount"] = float(row["Amount"])
            expenses.append(row)
    return expenses

# show monthly summery and chart
# TODO: maybe add yearly overview later
def monthly_summary():
    expenses = load_expenses()
    month = input("Enter month (YYYY-MM): ")
    if not month:
        month = datetime.today().strftime('%Y-%m')

    total = 0
    category_totals = defaultdict(float)
    print(category_totals)
    if month not in [exp["Date"][:7] for exp in expenses]:
        print(f"No expenses found for {month}")
        return

    for exp in expenses:
        if exp["Date"].startswith(month):
            total += exp["Amount"]
            category_totals[exp["Category"]] += exp["Amount"]

    print(f"Total Expenses for {month}: ₹{total}")

    print("\nCategory-wise breakdown:")
    for cat, amt in category_totals.items():
        print(f"{cat}: ₹{amt}")

    if category_totals:
        highest = max(category_totals, key=category_totals.get)
        print(f"Highest spending category: {highest}")

        plot_pie_chart(category_totals)

def plot_pie_chart(category_totals):
    labels = category_totals.keys()
    sizes = category_totals.values()

    plt.figure()
    plt.pie(sizes, labels=labels, autopct='%1.1f%%')
    plt.title("Expense Distribution")
    plt.show()

def menu():
    initialize_file()  # make sure file exists first

    while True:
        print("\n===== Expense Tracker =====")
        print("1. Add Expense")
        print("2. Monthly Summary")
        print("3. Exit")

        choice = input("Choose an option: ")

        if choice == "1":
            add_expense()
        elif choice == "2":
            monthly_summary()
        elif choice == "3":
            print("bye")
            break
        else:
            print("Invalid choice")

menu()