###custom Flask endpoint that returns all HTTP request headers in the body of the HTTP response.
##jgarta-codesource
from flask import Flask, jsonify, request, render_template_string

app = Flask(__name__)

@app.route('/')
def homepage():
    headers_html = """
    <!DOCTYPE html>
    <html>
    <head><title>Request Headers</title></head>
    <body>
        <h1>HTTP Request Headers</h1>
        <ul>
        {% for key, value in headers.items() %}
            <li><strong>{{ key }}:</strong> {{ value }}</li>
        {% endfor %}
        </ul>
    </body>
    </html>
    """
    return render_template_string(headers_html, headers=dict(request.headers))

@app.route('/secure')
def secure_page():
    if request.headers.get('Host') != 'tunnel.jgarta.services':
        return 'Forbidden', 403
    return "This is a secure page"

if __name__ == '__main__':
    app.run(debug=True)
