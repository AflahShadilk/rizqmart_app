require("dotenv").config();

const { setGlobalOptions } = require("firebase-functions/v2");
const { onRequest } = require("firebase-functions/v2/https");

const express = require("express");
const cors = require("cors");
const Stripe = require("stripe");
const cloudinary = require("cloudinary").v2;

/* ---------------- Global Options ---------------- */

setGlobalOptions({ maxInstances: 10 });

/* ---------------- Express App ---------------- */

const app = express();
app.use(cors({ origin: true }));
app.use(express.json({ limit: "10mb" }));

/* ---------------- Stripe Setup ---------------- */

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

/* ---------------- Cloudinary Setup ---------------- */

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.API_KEY,
  api_secret: process.env.SECRET_KEY,
});

/* ---------------- Health Check ---------------- */

app.get("/health", (req, res) => {
  res.status(200).send({ status: "ok" });
});

/* ---------------- Create Payment Intent ---------------- */

app.post("/create-payment-intent", async (req, res) => {
  try {
    const { amount, currency, orderId } = req.body;

    // ---------------- Request Validation ----------------
    if (!amount || typeof amount !== "number" || amount <= 0) {
      return res.status(400).send({ error: "Invalid or missing 'amount'" });
    }
    if (!currency || typeof currency !== "string") {
      return res.status(400).send({ error: "Invalid or missing 'currency'" });
    }

    // ---------------- Create Stripe Customer ----------------
    const customer = await stripe.customers.create();

    // ---------------- Create Ephemeral Key ----------------
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: "2023-10-16" }
    );

    // ---------------- Create Payment Intent ----------------
    const amountInSmallestUnit = Math.round(amount);

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInSmallestUnit,
      currency: currency.toLowerCase(),
      customer: customer.id,
      automatic_payment_methods: { enabled: true },
      metadata: {
        order_id: orderId || "",
        source: "RizqMart",
      },
    });

    // ---------------- Return Response ----------------
    res.status(200).send({
      success: true,
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      customerId: customer.id,
      ephemeralKey: ephemeralKey.secret,
    });
  } catch (error) {
    console.error("Stripe Error:", error.message);
    res.status(500).send({ error: error.message });
  }
});

/* ---------------- Confirm Payment Intent ---------------- */

app.post("/confirm-payment", async (req, res) => {
  try {
    const { paymentIntentId } = req.body;

    // ---------------- Request Validation ----------------
    if (!paymentIntentId || typeof paymentIntentId !== "string") {
      return res
        .status(400)
        .send({ error: "Invalid or missing 'paymentIntentId'" });
    }

    // ---------------- Retrieve Payment Intent ----------------
    const paymentIntent =
      await stripe.paymentIntents.retrieve(paymentIntentId);

    // ---------------- Return Response ----------------
    res.status(200).send({
      success: paymentIntent.status === "succeeded",
      status: paymentIntent.status,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
    });
  } catch (error) {
    console.error("Stripe Confirm Error:", error.message);
    res.status(500).send({ error: error.message });
  }
});

/* ---------------- Refund Payment ---------------- */

app.post("/refund-payment", async (req, res) => {
  try {
    const { paymentIntentId, amount } = req.body;

    // ---------------- Request Validation ----------------
    if (!paymentIntentId || typeof paymentIntentId !== "string") {
      return res
        .status(400)
        .send({ error: "Invalid or missing 'paymentIntentId'" });
    }

    // ---------------- Create Refund ----------------
    const refundParams = { payment_intent: paymentIntentId };
    if (amount && typeof amount === "number" && amount > 0) {
      refundParams.amount = Math.round(amount);
    }

    await stripe.refunds.create(refundParams);

    // ---------------- Return Response ----------------
    res.status(200).send({ success: true });
  } catch (error) {
    console.error("Stripe Refund Error:", error.message);
    res.status(500).send({ error: error.message });
  }
});

/* ---------------- Cloudinary Image Upload ---------------- */

app.post("/upload-image", async (req, res) => {
  try {
    const { image } = req.body;

    // ---------------- Request Validation ----------------
    if (!image || typeof image !== "string") {
      return res.status(400).send({ error: "Invalid or missing 'image'" });
    }

    // ---------------- Upload to Cloudinary ----------------
    const result = await cloudinary.uploader.upload(image, {
      folder: "rizqmart",
    });

    // ---------------- Return Response ----------------
    res.status(200).send({
      url: result.secure_url,
    });
  } catch (error) {
    console.error("Cloudinary Error:", error.message);
    res.status(500).send({ error: error.message });
  }
});

/* ---------------- Export API ---------------- */

exports.api = onRequest(app);