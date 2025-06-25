
# Oracle Free Tier: AMD Instance + VPN Setup for Securing OKE Services

This guide provides step-by-step instructions to deploy a free AMD instance within your Oracle Free Tier account, attach it to an existing Virtual Cloud Network (VCN) hosting your Oracle Kubernetes Engine (OKE), and configure a VPN on the AMD instance to secure access to your OKE workloads.

---

## Prerequisites

- Active Oracle Free Tier Account
- Existing VCN with working OKE Cluster (with at least 1 node: 1 OCPU, 6GB RAM)
- SSH key pair generated for instance access
- Familiarity with basic Linux commands

---

## Step 1: Deploy Free AMD Instance in Same VCN

1. Login to [Oracle Cloud Console](https://cloud.oracle.com/).
2. Navigate to **Compute** → **Instances** → **Create Instance**.
3. Under **Shape**, select:
   - *Always Free eligible AMD VM.Standard.A1.Flex* or *Always Free eligible VM.Standard.E2.1.Micro*
   - Allocate 1 OCPU and 6GB RAM (or less within free tier limits) if choosing VM.Standard.A1.Flex.
4. Choose Ubuntu 22.04 for the **Image**

5. **Networking**:
   - Choose **Existing VCN** (the one hosting your OKE).
   - Place instance in the same subnet or private subnet as desired.
6. **Boot Volume**:
   - Accept defaults within free tier storage.
7. **SSH Keys**:
   - Upload your public SSH key.
8. Launch the instance.

**Note:** Confirm security lists allow SSH (port 22) from your IP.

---

## Step 2: Install VPN (WireGuard Recommended)

1. SSH into the AMD instance:

```bash
ssh -i /path/to/private_key opc@<public_ip>
```

2. Update packages:

```bash
sudo apt update -y
sudo apt install wireguard -y
```

3. Generate WireGuard keys:

```bash
wg genkey | tee privatekey | wg pubkey > publickey
```

4. Configure WireGuard Server:

```bash
sudo nano /etc/wireguard/wg0.conf
```

Example `wg0.conf`:

```
[Interface]
Address = 10.10.10.1/24
ListenPort = 51820
PrivateKey = <contents_of_privatekey>

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.10.10.2/32
```

5. Enable IP Forwarding:

```bash
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

6. Start WireGuard:

```bash
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
```

7. Adjust Firewall:

```bash
sudo iptables -A INPUT -p udp --dport 51820 -j ACCEPT
```

---

## Step 3: Configure VPN Client

1. Install WireGuard.
2. Example Client Config:

```
[Interface]
PrivateKey = <client_private_key>
Address = 10.10.10.2/24
DNS = 10.10.10.1

[Peer]
PublicKey = <server_public_key>
Endpoint = <server_public_ip>:51820
AllowedIPs = 10.10.10.0/24, 10.0.0.0/16
PersistentKeepalive = 25
```

3. Start VPN:

```bash
sudo wg-quick up wg0
```

Test:

```bash
ping 10.10.10.1
```

You should be able to reach your AMD instance via VPN.

---

## Step 4: Setup Local DNS Server on VPN Instance

1. Install dnsmasq:

```bash
sudo apt install dnsmasq -y
```

2. Configure dnsmasq:

```bash
sudo nano /etc/dnsmasq.d/vpn-dns.conf
```

Example:

```
interface=wg0
listen-address=10.10.10.1
listen-address=127.0.0.1
bind-interfaces
domain=your.domain
address=/dashboard.your.domain/10.0.10.96
```

3. Restart dnsmasq:

```bash
sudo systemctl restart dnsmasq
```

4. Update `/etc/resolv.conf`:

```bash
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf'
```

---

## Troubleshooting & Diagnostics Summary

**Issues Encountered:**
- VPN handshake failures (incorrect firewall rules, incorrect IP assignment)
- Port 51820 appearing closed (security list or firewall conflict)
- DNS resolution failing inside VPN (misconfigured dnsmasq or client settings)

**Diagnostics Used:**
- `sudo iptables -L -v -n` → Verify firewall rules
- `sudo nft list ruleset` → Confirm low-level packet filtering
- `sudo tcpdump -i any port 51820` → Check if WireGuard packets arrive

**Fixes Applied:**
- Ensured port 51820 UDP allowed in security lists and iptables
- Corrected VPN server and client IP/subnet configurations
- Deployed dnsmasq bound to VPN interface
- Updated WireGuard client with `DNS = 10.10.10.1` for VPN-only DNS
- Validated connectivity with `ping` and `nslookup`

---

## References

- [Oracle Free Tier Documentation](https://www.oracle.com/cloud/free/)
- [WireGuard Official](https://www.wireguard.com/install/)
- [Cert-Manager with Cloudflare](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)

