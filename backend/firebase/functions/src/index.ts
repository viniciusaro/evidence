/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall} from "firebase-functions/v2/https";
import {GoogleGenerativeAI} from "@google/generative-ai";
import {defineSecret} from "firebase-functions/params";
import {onInit} from "firebase-functions/v2/core";
import admin = require("firebase-admin")
import * as logger from "firebase-functions/logger";

admin.initializeApp();

const apiKey = defineSecret("GEMINI_API_KEY");
let genAI: GoogleGenerativeAI;

onInit(() => {
  genAI = new GoogleGenerativeAI(apiKey.value());
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const geminiBotCallable = onCall(async (request) => {
  logger.info("on request");
  logger.info("user_id: " + request.auth?.token.uid);

  const idToken = request.rawRequest.headers.authorization?.split("Bearer ")[1];
  await admin.auth().verifyIdToken(idToken ?? "");

  const message = request.data["message"] as string;
  logger.info("message received: " + message);

  const model = genAI.getGenerativeModel({model: "gemini-1.5-flash"});
  const result = await model.generateContent("Em poucas linhas: " + message);
  const responseText = result.response.text();
  return responseText;
});
