import db


def dispatch(path):
    choice = {'/mentors': {'query': 1,
                           'title': 'Mentors and Schools',
                           'data_label': ('first_name', 'last_name', 'name', 'country'),
                           'header': ('First Name', 'Last Name', 'School', 'Country')},
              '/all-school': {'query': 2,
                              'title': 'All schools',
                              'data_label': ('first_name', 'last_name', 'name', 'country'),
                              'header': ('First Name', 'Last Name', 'School', 'Country')},
              '/mentors-by-country': {'query': 3,
                                      'title': 'Mentors by country',
                                      'data_label': ('country', 'count'),
                                      'header': ('Country', 'Count')},
              '/contacts': {'query': 4,
                            'title': 'Contacts',
                            'data_label': ('name', 'first_name', 'last_name'),
                            'header': ('School', 'First Name', 'Last Name')},
              '/applicants': {'query': 5,
                              'title': 'Applicants',
                              'data_label': ('first_name', 'application_code', 'creation_date'),
                              'header': ('Applicant First Name', 'Application Code', 'Application Date')},
              '/applicants-and-mentors': {'query': 6,
                                          'title': 'Applicants and Mentors',
                                          'data_label': ('applicant_first_name', 'application_code',
                                                         'mentor_first_name', 'mentor_last_name'),
                                          'header': ('Applicant First Name', 'Application Code', 'Mentor First Name',
                                                     'Mentor Last Name')}
              }

    result = {'title': choice[path]['title'],
              'header': choice[path]['header'],
              'data_label': choice[path]['data_label'],
              'body': select_solution(choice[path]['query'])
              }
    return result


def select_solution(n):
    records = None
    if n in range(1, 7):
        with db.get_cursor() as cursor:
            sql = """SELECT * FROM solution{}""".format(n)
            cursor.execute(sql)
            records = cursor.fetchall()
    return records
