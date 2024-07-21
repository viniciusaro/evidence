/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import {GoogleGenerativeAI} from "@google/generative-ai";
import {defineSecret} from "firebase-functions/params";
import {onInit} from "firebase-functions/v2/core";
import * as logger from "firebase-functions/logger";

const apiKey = defineSecret("GEMINI_API_KEY");
let genAI: GoogleGenerativeAI;

onInit(() => {
  genAI = new GoogleGenerativeAI(apiKey.value());
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const geminiBot = onRequest(async (request, response) => {
  logger.info("on request");
  const message = request.body["message"];
  logger.info("message received: " + message);

  const model = genAI.getGenerativeModel({model: "gemini-1.5-flash"});
  const result = await model.generateContent(message);
  const responseText = result.response.text();
  response.send(responseText);
});
