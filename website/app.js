// 🔴 REPLACE this with your actual API Gateway URL
const API_BASE_URL = "https://jkbwtb89n6.execute-api.ap-southeast-1.amazonaws.com/prod";

async function submitMessage() {
  const input = document.getElementById("messageInput");
  const message = input.value.trim();

  if (!message) {
    alert("Please enter a message");
    return;
  }

  await fetch(`${API_BASE_URL}/message`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ message })
  });

  input.value = "";
  loadMessages();
}

async function loadMessages() {
  const list = document.getElementById("messagesList");
  list.innerHTML = "<li>Loading...</li>";

  try {
    const response = await fetch(`${API_BASE_URL}/messages`);
    const data = await response.json();

    list.innerHTML = "";

    if (data.length === 0) {
      list.innerHTML = "<li>No messages yet</li>";
      return;
    }

    data.forEach(item => {
      const li = document.createElement("li");
      li.textContent = item.message;
      list.appendChild(li);
    });

  } catch (err) {
    list.innerHTML = "<li>Error loading messages</li>";
  }
}

// Load messages on page load
window.onload = loadMessages;