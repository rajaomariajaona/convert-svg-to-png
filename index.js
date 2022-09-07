const { convert } = require('convert-svg-to-png');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors())
app.use(express.text())

app.post('/save-png', async(req, res) => {
  console.log(req.body);
  const png = await convert(req.body,{
    puppeteer: {
        args: ['--no-sandbox', '--disable-setuid-sandbox']
  }});

  res.set('Content-Type', 'image/png');
  res.send(png);
});
app.post("/save-svg", async(req, res) => {
    res.set('Content-Type', 'image/svg+xml');
    res.send(req.body);
})

app.listen(3000);