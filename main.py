import db
import os
import random


def menu():
    '''
    Contains titles for menu with corresponding table headers.
        @return   tuple of dictionaries   Menu title with table headers for printing
    '''
    menu = ({'Show name of mentors': ['First Name', 'Last Name']},
            {'Show nick names of all mentors working at given city': ['Nick Name']},
            {'Show full name, phone number based on first name': ['Full Name', 'Phone Number']},
            {'Show full name, phone number based on email': ['Full Name', 'Phone Number']},
            {'Add new applicant': ['Full Name', 'Phone Number', 'Email', 'Student Code']},
            {'Change phone number based on name': ['Full Name', 'Phone Number']},
            {'Delete applicant based on email ending': ['Full Name', 'Phone Number', 'Email', 'Student Code']},
            {'Exit': []}
            )
    return menu


def handle_choice(choice):
    '''
    Dispatch based on user choice.
        @param    choice   int       Number of menu item the user has selected
        @return            boolean   False if Exit is selected, otherwise True
    '''
    query_result = None

    if choice == 1:
        query_result = get_mentors()
    elif choice == 2:
        query_result = get_mentor_nicks()
    elif choice == 3:
        query_result = get_applicants_by_name()
    elif choice == 4:
        query_result = get_applicants_by_email()
    elif choice == 5:
        user_input = get_user_input(('first_name', 'last_name', 'phone_number', 'email'))
        query_result = add_new_applicants(user_input)
    elif choice == 6:
        user_input = get_user_input(('first_name', 'last_name', 'phone_number'))
        query_result = change_phone_by_name(user_input)
    elif choice == 7:
        user_input = get_user_input(('email',))
        query_result = remove_applicant_by_email(user_input)
    elif choice == 8:
        status = False
    else:
        raise ValueError

    if choice != 8:
        status = True

    result = {'status': status, 'data': query_result}
    return result


def get_user_input(for_):
    '''
    Asks user for input.
        @param    for_    tuple    Defines what input we want from the user
        @return           dict     The user input
    '''
    answer = {}

    if 'menu' in for_:
        answer['menu'] = int(input('Enter your choice: '))

    if 'first_name' in for_:
        answer['first_name'] = input('\nFirst Name: ')

    if 'last_name' in for_:
        answer['last_name'] = input('\nLast Name: ')

    if 'phone_number' in for_:
        answer['phone_number'] = input('\nPhone Number: ')

    if 'email' in for_:
        answer['email'] = input('\nEmail: ')

    return answer


def get_mentors():
    '''
    SQL query for menu #1
        @return   list of tuples   The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        cursor.execute("""SELECT first_name,
                                 last_name
                          FROM mentors;""")
        records = cursor.fetchall()
    return records


def get_mentor_nicks():
    '''
    SQL query for menu #2
        @return   list of tuples   The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        cursor.execute("""SELECT nick_name
                          FROM mentors
                          WHERE city = 'Miskolc';""")
        records = cursor.fetchall()
    return records


def get_applicants_by_name():
    '''
    SQL query for menu #3
        @return   list of tuples   The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        cursor.execute("""SELECT first_name || ' ' || last_name as full_name,
                                 phone_number
                          FROM applicants
                          WHERE first_name LIKE '%Carol%';""")
        records = cursor.fetchall()
    return records


def get_applicants_by_email():
    '''
    SQL query for menu #4
        @return   list of tuples   The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        cursor.execute("""SELECT first_name || ' ' || last_name as full_name,
                                 phone_number
                          FROM applicants
                          WHERE email LIKE '%@adipiscingenimmi.edu';""")
        records = cursor.fetchall()
    return records


def add_new_applicants(user_input):
    '''
    SQL query for menu #5
        @param     user_input    dict              User input needed for the query
        @return                  list of tuples    The records yielded by the query
    '''
    user_input['application_code'] = generate_application_code()

    with db.get_cursor() as cursor:
        sql = """INSERT INTO applicants (first_name,
                                         last_name,
                                         phone_number,
                                         email,
                                         application_code)
                 VALUES (%s, %s, %s, %s, %s);"""

        data = (user_input['first_name'],
                user_input['last_name'],
                user_input['phone_number'],
                user_input['email'],
                user_input['application_code'])

        cursor.execute(sql, data)

        sql2 = """SELECT first_name || ' ' || last_name as full_name,
                         phone_number,
                         email,
                         application_code
                  FROM applicants
                  WHERE application_code = %s;"""

        data2 = (user_input['application_code'],)

        cursor.execute(sql2, data2)
        records = cursor.fetchall()
    return records


def change_phone_by_name(user_input):
    '''
    SQL query for menu #6
        @param     user_input    dict              User input needed for the query
        @return                  list of tuples    The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        sql = """UPDATE applicants
                 SET phone_number = %s
                 WHERE first_name = %s AND last_name = %s;"""
        data = (user_input['phone_number'],
                user_input['first_name'],
                user_input['last_name']
                )
        cursor.execute(sql, data)

        sql2 = """SELECT first_name || ' ' || last_name as full_name,
                         phone_number
                  FROM applicants
                  WHERE first_name = %s AND last_name = %s;"""
        data2 = (user_input['first_name'],
                 user_input['last_name']
                 )
        cursor.execute(sql2, data2)
        records = cursor.fetchall()
    return records


def remove_applicant_by_email(user_input):
    '''
    SQL query for menu #7
        @param     user_input    dict              User input needed for the query
        @return                  list of tuples    The records yielded by the query
    '''
    with db.get_cursor() as cursor:
        sql = """DELETE FROM applicants
                 WHERE email LIKE '%%' || %s;"""
        data = (user_input['email'],)
        cursor.execute(sql, data)

        sql2 = """SELECT first_name || ' ' || last_name as full_name,
                         phone_number,
                         email,
                         application_code
                  FROM applicants;"""
        cursor.execute(sql2)
        records = cursor.fetchall()
    return records


def generate_application_code():
    '''
    Generates application code for applicant.
        @return   int   The generated application code
    '''
    status = True

    with db.get_cursor() as cursor:
        sql = """SELECT application_code
                FROM applicants"""
        cursor.execute(sql)
        records = cursor.fetchall()

    while status:
        code = (random.randint(10000, 99999),)
        if code not in records:
            status = False

    return code


def print_menu():
    '''
    Prints main menu.
        @return   None
    '''
    get_menu = menu()
    os.system('clear')
    print('\n', '*' * 15, sep='')
    print('*  MAIN MENU  *')
    print('*' * 15, '\n', sep='')
    for i, item in enumerate(get_menu):
        print('{}. {}'.format(i + 1, *item.keys()))
    print('\n')


def print_table(table, choice):
    '''
    Prints out results to the screen based on the choice of the user.
        @param    table    list   The records to be printed out
        @param    choice   int    Number of option selected by the user
        @return            None   Void
    '''
    get_menu = menu()[choice - 1]
    key = tuple(get_menu.keys())[0]
    fields_num = len(table[0])
    fields_length = [max(len(str(record[field])) for record in table) for field in range(fields_num)]

    # header correction
    headers_length = [len(str(title)) for title in get_menu[key]]
    max_fields_length = list(zip(fields_length, headers_length))
    max_fields_length = [max(item) for item in max_fields_length]

    # whitespace correction
    max_fields_length = list(map(lambda x: x + 2, max_fields_length))

    # format table field width
    field_width = []
    for field in range(fields_num):
        field_width = field_width + ['{:<' + str(max_fields_length[field]) + '}']
    field_width = ' | '.join(field_width)

    # draw table
    os.system('clear')
    table_length = sum(max_fields_length) + 1 + 3 * fields_num
    print('-' * table_length)
    print(('| ' + field_width).format(*get_menu[key]) + ' |')
    print('-' * table_length)
    [print(('| ' + field_width).format(*line) + ' |') for line in table]
    print('-' * table_length)
    input('Press Enter to continue')


def main():
    status = True

    while status:
        print_menu()
        choice = get_user_input(('menu',))['menu']
        if choice in range(len(menu()) + 1):
            perform_choice = handle_choice(choice)
            status = perform_choice['status']
            if status:
                print_table(perform_choice['data'], choice)
        else:
            raise KeyError('Please select a valid option.')

    print('\nGoodbye!\n')

if __name__ == '__main__':
    main()
