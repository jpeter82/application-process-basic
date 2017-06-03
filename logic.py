import db


def select_solution(n):
    records = None
    if n in range(1, 7):
        with db.get_cursor() as cursor:
            sql = """SELECT * FROM solution{}""".format(n)
            cursor.execute(sql)
            records = cursor.fetchall()
    return records
