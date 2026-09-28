import 'dart:js_interop';
import 'package:web/web.dart';

void main() {
  document.body!.innerHTML = '''
    <style>
      * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
      }

      body {
        font-family: Arial, sans-serif;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(135deg, #667eea, #764ba2);
      }

      .card {
        width: 420px;
        padding: 45px 35px;
        text-align: center;
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.25);
        border-radius: 25px;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
        color: white;
      }

      h1 {
        font-size: 42px;
        margin-bottom: 15px;
      }

      p {
        font-size: 18px;
        margin-bottom: 30px;
        opacity: 0.9;
      }

      button {
        border: none;
        padding: 14px 30px;
        font-size: 17px;
        font-weight: bold;
        border-radius: 30px;
        cursor: pointer;
        background: white;
        color: #667eea;
        transition: 0.3s;
      }

      button:hover {
        transform: scale(1.08);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
      }

      #message {
        margin-top: 25px;
        font-size: 20px;
        font-weight: bold;
        min-height: 25px;
      }
    </style>

    <div class="card">
      <h1>Hello World! 👋</h1>

      <p>
        Welcome to my interactive Dart application.
      </p>

      <button id="btn">Click Me ✨</button>

      <div id="message"></div>
    </div>
  '''.toJS;

  final button = document.querySelector('#btn')!;
  final message = document.querySelector('#message')!;

  button.addEventListener(
    'click',
    ((Event event) {
      message.textContent = '🎉 You clicked the button!';
    }).toJS,
  );
}