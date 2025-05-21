const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// ❗ Энд өөрийн GPT API key-г тавина
const OPENAI_API_KEY = "sk-proj-..."  // ← та өөрийн sk-proj-... түлхүүрээ энд тавина

app.post("/chat", async (req, res) => {
  const userMessage = req.body.message || "What is paracetamol?";

  try {
    const response = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are a helpful medical assistant." },
          { role: "user", content: userMessage },
        ],
        temperature: 0.7,
        max_tokens: 300,
      },
      {
        headers: {
          Authorization: `Bearer ${OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    res.status(200).json(response.data);
  } catch (error) {
    console.error("GPT Error:", error.response?.data || error.message);
    res.status(500).json({ error: "GPT call failed" });
  }
});

// Firebase Function нэр → openai
exports.openai = functions.https.onRequest(app);
