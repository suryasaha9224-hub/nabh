<?php
// process_ai_chat.php
error_reporting(0);
header('Content-Type: application/json');

// ==============================================================================
// 1. GEMINI API KEY
// ==============================================================================
$api_key = 'API KEY PASTE HERE'; 

$message = $_POST['message'] ?? '';

if (empty($message)) {
    echo json_encode(['status' => 'error', 'message' => 'Please provide a message.']);
    exit;
}

// 2. Prepare the payload for Gemini 1.5 Flash
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" . $api_key;

$data = [
    "systemInstruction" => [
        "role" => "model",
        "parts" => [
            [
                "text" => "You are an intelligent support assistant for the 'NABH Guardian' hospital asset management system. Be concise, professional, and helpful. Use markdown for bolding important terms."
            ]
        ]
    ],
    "contents" => [
        [
            "role" => "user",
            "parts" => [
                ["text" => $message]
            ]
        ]
    ],
    "generationConfig" => [
        "temperature" => 0.7,
        "maxOutputTokens" => 800
    ]
];

$json_data = json_encode($data);

// 3. Execute cURL request to Google Gemini API
$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json'
]);

// --- NEW FIX FOR "COULD NOT RESOLVE HOST" ---
// Forces cURL to use IPv4. Local servers often fail trying to resolve Google APIs over IPv6.
curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4); 

// Disable SSL verification for local dev environments (XAMPP/WAMP) to prevent connection blocks
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false); 

$response = curl_exec($ch);
$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$error = curl_error($ch);
curl_close($ch);

// Handle Network or cURL execution errors
if ($error) {
    echo json_encode(['status' => 'error', 'message' => 'cURL Error: ' . $error]);
    exit;
}

// 4. Parse the response
$decoded_response = json_decode($response, true);

if ($httpcode >= 200 && $httpcode < 300) {
    if (isset($decoded_response['candidates'][0]['content']['parts'][0]['text'])) {
        $ai_reply = $decoded_response['candidates'][0]['content']['parts'][0]['text'];
        echo json_encode(['status' => 'success', 'reply' => trim($ai_reply)]);
    } else {
        // Return raw response for debugging if format is unexpected
        echo json_encode(['status' => 'error', 'message' => 'Unexpected AI format. Raw: ' . $response]);
    }
} else {
    // Return exactly what Google API says (e.g. "API key not valid", "Quota exceeded")
    $error_msg = $decoded_response['error']['message'] ?? 'Unknown API Error';
    echo json_encode(['status' => 'error', 'message' => "HTTP $httpcode: $error_msg"]);
}
?>