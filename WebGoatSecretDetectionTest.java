package org.owasp.webgoat.lessons.security;

/**
 * TEST FIXTURES ONLY: intentionally hardcoded, synthetic secret-like values for
 * validating OpenGrep/SSD secret detection. None of these values are real.
 * Do not replace them with real credentials.
 */
public final class WebGoatSecretDetectionTest {
    // AWS-style access key ID (synthetic)
    private static final String AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE";

    // AWS-style secret access key (synthetic)
    private static final String AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";

    // GitHub personal access token-shaped test value (synthetic)
    private static final String GITHUB_TOKEN = "ghp_0123456789abcdef0123456789abcdef0123";

    // Slack token-shaped test value (synthetic)
    private static final String SLACK_BOT_TOKEN = "xoxb-000000000000-000000000000-FAKE00000000000000000000";

    // Stripe test-key-shaped value (synthetic; not a usable credential)
    private static final String STRIPE_SECRET_KEY = "sk_test_FAKE000000000000000000000000000000";

    // Generic hardcoded credential patterns
    private static final String DATABASE_USERNAME = "webgoat_test_user";
    private static final String DATABASE_PASSWORD = "P@ssw0rd-DO-NOT-USE-123!";
    private static final String API_KEY = "api_key = 'FAKE_API_KEY_1234567890abcdef'";

    // Connection string containing a synthetic username and password
    private static final String DATABASE_URL =
            "jdbc:postgresql://localhost:5432/webgoat?user=test_user&password=FakeDbPass123!";

    // JWT-shaped dummy value; signature and claims are not valid credentials
    private static final String JWT_TOKEN =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
            + "eyJzdWIiOiJ0ZXN0LXVzZXIiLCJpc3MiOiJ3ZWJnb2F0LXRlc3QifQ."
            + "FAKE_SIGNATURE_NOT_A_REAL_TOKEN";

    // Private-key marker with deliberately invalid placeholder material
    private static final String PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----\n"
            + "THIS_IS_SYNTHETIC_TEST_DATA_NOT_A_REAL_PRIVATE_KEY\n"
            + "-----END PRIVATE KEY-----";

    private WebGoatSecretDetectionTest() {
        // Test fixture class; not intended to be instantiated.
    }

    public static void main(String[] args) {
        // Reference the values so they remain easy to find in scanner test runs.
        System.out.println("OpenGrep secret-detection test fixture loaded: "
                + AWS_ACCESS_KEY_ID + ", " + AWS_SECRET_ACCESS_KEY + ", "
                + GITHUB_TOKEN + ", " + SLACK_BOT_TOKEN + ", "
                + STRIPE_SECRET_KEY + ", " + DATABASE_USERNAME + ", "
                + DATABASE_PASSWORD + ", " + API_KEY + ", "
                + DATABASE_URL + ", " + JWT_TOKEN + ", " + PRIVATE_KEY);
    }
}
