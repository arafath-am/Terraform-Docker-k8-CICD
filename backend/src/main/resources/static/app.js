let products = [];
let cart = [];

async function loadProducts() {
    const search = document.getElementById('searchInput').value;
    const url = search ? `/api/products?search=${encodeURIComponent(search)}` : '/api/products';
    const response = await fetch(url);
    products = await response.json();
    renderProducts();
}

function renderProducts() {
    const container = document.getElementById('products');
    container.innerHTML = '';

    products.forEach(product => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${product.name}</h3>
            <p>${product.description || ''}</p>
            <p><strong>Category:</strong> ${product.category}</p>
            <p class="price">$${Number(product.price).toFixed(2)}</p>
            <p><strong>Stock:</strong> ${product.stockQuantity}</p>
            <button onclick="addToCart(${product.id})">Add to Cart</button>
        `;
        container.appendChild(card);
    });
}

function addToCart(productId) {
    const existing = cart.find(item => item.productId === productId);
    if (existing) {
        existing.quantity += 1;
    } else {
        cart.push({ productId, quantity: 1 });
    }
    renderCart();
}

function renderCart() {
    const container = document.getElementById('cart');
    container.innerHTML = '';

    if (cart.length === 0) {
        container.innerHTML = '<p>Your cart is empty.</p>';
        return;
    }

    let total = 0;

    cart.forEach(item => {
        const product = products.find(p => p.id === item.productId);
        const lineTotal = product ? Number(product.price) * item.quantity : 0;
        total += lineTotal;

        const row = document.createElement('div');
        row.className = 'cart-row';
        row.innerHTML = `
            <span>${product ? product.name : 'Product'} x ${item.quantity}</span>
            <span>$${lineTotal.toFixed(2)}</span>
        `;
        container.appendChild(row);
    });

    const totalRow = document.createElement('div');
    totalRow.className = 'cart-row';
    totalRow.innerHTML = `<strong>Total</strong><strong>$${total.toFixed(2)}</strong>`;
    container.appendChild(totalRow);
}

async function checkout() {
    const customerName = document.getElementById('customerName').value;
    const customerEmail = document.getElementById('customerEmail').value;
    const message = document.getElementById('message');

    if (!customerName || !customerEmail || cart.length === 0) {
        message.textContent = 'Please enter your name, email, and add at least one item.';
        return;
    }

    const response = await fetch('/api/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ customerName, customerEmail, items: cart })
    });

    if (response.ok) {
        const order = await response.json();
        message.textContent = `Order #${order.id} placed. Total: $${Number(order.totalAmount).toFixed(2)}`;
        cart = [];
        renderCart();
        await loadProducts();
    } else {
        const error = await response.text();
        message.textContent = `Checkout failed: ${error}`;
    }
}

loadProducts();
renderCart();
