# EHM Blockchain Project Overview
The EHM Blockchain project is an innovative research initiative from the School of Social Science that leverages blockchain technology to create a permanent, transparent record of scholarly interpretations of archival documents.
Core Concept
This project establishes a decentralized platform where experts can submit their interpretations and analyses of archival materials, with each contribution being securely stored on the blockchain. This approach offers several key advantages:

- Immutable Records: Once recorded on the blockchain, scholarly interpretations cannot be altered or deleted, creating a permanent historical record.
- Provenance Tracking: The origin and evolution of interpretations can be traced through time, allowing users to understand how scholarly consensus develops.
- Transparency: All contributions are publicly accessible, promoting open scholarship and knowledge sharing.
- Accountability: Scholars' contributions are verifiable and attributable, encouraging responsible scholarship.

# Technical Implementation
The project utilizes the Ethereum blockchain (currently on Sepolia testnet) with a permission-based structure:

- Owners: Administrators who can manage the platform and approve scholars
- Scholars: Vetted experts who can contribute interpretations to the blockchain
- Public: Anyone can view the interpretations and their history


# EHM Blockchain features

## Quick Start

1. Install MetaMask browser extension.
2. Get Sepolia testnet ETH from a faucet (e.g., https://www.alchemy.com/faucets/ethereum-sepolia).
3. Request owner access from the contract administrator.
4. Start a local server, e.g.: 
```
python3 -m http.server 8000
```

Open http://localhost:8000 in your browser.

<img src="https://github.com/user-attachments/assets/bb7ebfe2-7760-4a86-9f51-09c897c801a3" width="500" height="auto">

## Usage
1. Connect MetaMask when prompted.
2. Owners can add/remove owners and scholars, view scholar list.
3. Scholars can add edits to documents.
4. Anyone can view edits for a specific document.
