// flutter run -d chrome --web-renderer html --web-port 50073
// sonra proxy'yi kullanmak için: node web/dev.proxy.js

const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");

const app = express();

app.use(
  "/proxy",
  createProxyMiddleware({
    target: "https://worldpass-beta.heptapusgroup.com",
    changeOrigin: true,
    secure: true,
    pathRewrite: { "^/proxy": "" },
  })
);

const port = 5051;
app.listen(port, () => console.log("DEV proxy listening on http://localhost:" + port));
