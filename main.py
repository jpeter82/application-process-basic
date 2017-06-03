from flask import Flask, request, render_template, url_for
import logic


app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/applicants-and-mentors')
@app.route('/applicants')
@app.route('/contacts')
@app.route('/mentors-by-country')
@app.route('/all-school')
@app.route('/mentors')
def select_table():
    data = logic.dispatch(request.path)
    return render_template('table.html', table=data)


@app.errorhandler(404)
def page_not_found(error):
    return 'Oops, page not found!', 404


if __name__ == '__main__':
    app.run(debug=True)
