
# 🧪 Creating a Lambda Test Function via AWS Web Interface

This guide walks you through creating a **test AWS Lambda function** using the AWS Console. It’s perfect for testing workflows in `n8n` or validating IAM permissions from your EC2 instance.

---

## ✅ Step 1: Open the Lambda Console

1. Go to the AWS Console
2. Navigate to **Services → Lambda**
3. Click **“Create function”**

---

## 🛠️ Step 2: Configure the Lambda Function

### Basic Info:

- **Function name**: `n8nTestFunction` (or any name you prefer)
- **Runtime**: Choose `Python 3.12`, `Node.js`, or your preferred language
- **Permissions**:  
  - Choose **“Create a new role with basic Lambda permissions”**

> ✅ This gives the function permission to write logs to CloudWatch.

Click **“Create function”**.

---

## ✏️ Step 3: Add Sample Code

Once the function is created:

1. In the **Function code** editor, enter the following simple test code.

### Example for **Node.js 18.x**:

```javascript
exports.handler = async (event) => {
    console.log("Event Received:", event);
    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Lambda test successful!" }),
    };
};
```

### Example for **Python 3.12**:

```python
def lambda_handler(event, context):
    print("Event received:", event)
    return {
        'statusCode': 200,
        'body': 'Lambda test successful!'
    }
```

Click **Deploy** to save your changes.

---

## 🚀 Step 4: Test the Function Manually

1. Click the **“Test”** button in the top right
2. Configure a test event:
   - **Event name**: `testEvent`
   - **Template**: Choose `Hello World` or leave default
3. Click **Save**, then **Test**

> 🟢 You should see a `200` response and `Lambda test successful!` in the output.

---

## 🌐 Step 5: Enable Access from n8n (Optional)

If you plan to invoke this Lambda function from `n8n`:

- Ensure your EC2 IAM role includes the following permission:

```json
{
  "Effect": "Allow",
  "Action": "lambda:InvokeFunction",
  "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:n8nTestFunction"
}
```

Replace `REGION`, `ACCOUNT_ID`, and function name as needed.

---

## ✅ Summary

You now have a working test Lambda function you can invoke from:

- The AWS Console (manually)
- A script or CLI (e.g., AWS CLI)
- An `n8n` workflow via the **AWS Lambda node**

---
