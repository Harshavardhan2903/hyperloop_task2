const express = require('express');
const mqtt = require('mqtt');
const WebSocket = require('ws');

const app = express();
const port = 3000;

const mqttBrokerUrl = 'mqtt://broker.emqx.io';
const mqttClient = mqtt.connect(mqttBrokerUrl);

const wss = new WebSocket.Server({ port: 8080 });

mqttClient.on('connect', () => {
  console.log('Connected to MQTT Broker');
  mqttClient.subscribe('kipot/outTopic');
});

mqttClient.on('message', (topic, message) => {
  console.log(`Received message: ${message.toString()} on topic: ${topic}`);
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message.toString());
    }
  });
});

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

app.listen(port, () => {
  console.log(`Web server listening at http://localhost:${port}`);
});
