const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// Real estate photos from Unsplash (high-quality, free-to-use images)
const realEstatePhotos = {
    luxury: [
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687644-aac4c3eac7f4?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1600&h=900',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1600&h=900',
        'https://images.unsplash.com/photo-1600573472550-8090b5e0745e?w=1600&h=900',
        'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1600&h=900',
        'https://images.unsplash.com/photo-1599809275671-b5942cabc7a2?w=1600&h=900'
    ],
    modern: [
        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687126-c2f37b80c88e?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687664-2b5f7a11c7b7?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687710-040798eea3e5?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687644-aac4c3eac7f4?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687454-e45708b3f3a5?w=1600&h=900',
        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1600&h=900'
    ],
    traditional: [
        'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753251-ae9a5a9f6b99?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753421-56d96fb96fe8?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753447-6c7b55d96a25?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753497-bcd5ce069d82?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753534-c7716ba14f47?w=1600&h=900',
        'https://images.unsplash.com/photo-1600566753581-78a58441d534?w=1600&h=900'
    ]
};

const testListings = [
    {
        listingId: "TX-123456",
        address: {
            street: "1234 Lake Austin Blvd",
            city: "Austin",
            state: "TX",
            zip: "78703"
        },
        price: 2450000,
        propertyType: "Luxury Villa",
        bedrooms: 5,
        bathrooms: 4.5,
        squareFeet: 4200,
        description: "Stunning waterfront villa with panoramic views of Lake Austin. This architectural masterpiece features floor-to-ceiling windows, a gourmet kitchen with top-of-the-line appliances, and a resort-style infinity pool.",
        features: [
            "Waterfront Property",
            "Infinity Pool",
            "Smart Home System",
            "Wine Cellar",
            "Home Theater",
            "4-Car Garage"
        ],
        photos: realEstatePhotos.luxury,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Sarah Johnson",
            brokerage: "Luxury Homes Austin"
        },
        likeCount: 0
    },
    {
        listingId: "TX-789012",
        address: {
            street: "567 Congress Ave",
            city: "Austin",
            state: "TX",
            zip: "78701"
        },
        price: 1250000,
        propertyType: "Modern Condo",
        bedrooms: 3,
        bathrooms: 2.5,
        squareFeet: 2100,
        description: "Ultra-modern downtown condo with stunning city views. Features include an open concept living area, designer finishes, and a large private terrace perfect for entertaining.",
        features: [
            "Floor-to-Ceiling Windows",
            "Private Terrace",
            "Concierge Service",
            "Fitness Center",
            "Secured Parking",
            "Pet Friendly"
        ],
        photos: realEstatePhotos.modern,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Michael Chen",
            brokerage: "Downtown Realty Group"
        },
        likeCount: 0
    },
    {
        listingId: "TX-345678",
        address: {
            street: "890 Travis Heights Blvd",
            city: "Austin",
            state: "TX",
            zip: "78704"
        },
        price: 1850000,
        propertyType: "Contemporary Home",
        bedrooms: 4,
        bathrooms: 3.5,
        squareFeet: 3200,
        description: "Beautifully renovated contemporary home in Travis Heights. Features include a chef's kitchen, primary suite with spa-like bathroom, and a backyard oasis with covered patio and pool.",
        features: [
            "Chef's Kitchen",
            "Pool",
            "Covered Patio",
            "Home Office",
            "Smart Home Features",
            "Solar Panels"
        ],
        photos: realEstatePhotos.modern,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Emily Rodriguez",
            brokerage: "Austin Elite Properties"
        },
        likeCount: 0
    },
    {
        listingId: "TX-901234",
        address: {
            street: "123 Tarrytown Rd",
            city: "Austin",
            state: "TX",
            zip: "78703"
        },
        price: 3200000,
        propertyType: "Traditional Estate",
        bedrooms: 6,
        bathrooms: 5.5,
        squareFeet: 5500,
        description: "Magnificent traditional estate in prestigious Tarrytown. This meticulously maintained home features formal living and dining rooms, a gourmet kitchen, and a private guest house.",
        features: [
            "Guest House",
            "Formal Gardens",
            "Library",
            "Wine Room",
            "Multiple Fireplaces",
            "Circular Driveway"
        ],
        photos: realEstatePhotos.traditional,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Robert Williams",
            brokerage: "Heritage Real Estate"
        },
        likeCount: 0
    },
    {
        listingId: "TX-567890",
        address: {
            street: "456 South Lamar Blvd",
            city: "Austin",
            state: "TX",
            zip: "78704"
        },
        price: 975000,
        propertyType: "Modern Townhouse",
        bedrooms: 3,
        bathrooms: 2.5,
        squareFeet: 1800,
        description: "Sleek and stylish townhouse in the heart of South Lamar. Features include high-end finishes, a rooftop deck with downtown views, and an attached two-car garage.",
        features: [
            "Rooftop Deck",
            "City Views",
            "Two-Car Garage",
            "Energy Efficient",
            "Custom Closets",
            "Outdoor Kitchen"
        ],
        photos: realEstatePhotos.modern,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Jessica Park",
            brokerage: "Urban Living Austin"
        },
        likeCount: 0
    }
];

exports.seedListings = functions.https.onRequest(async (req, res) => {
    try {
        // Clear existing listings
        const existingListings = await db.collection('listings').get();
        const batch = db.batch();
        existingListings.docs.forEach((doc) => {
            batch.delete(doc.ref);
        });
        await batch.commit();

        // Add new listings
        const newBatch = db.batch();
        testListings.forEach((listing) => {
            const docRef = db.collection('listings').doc(listing.listingId);
            newBatch.set(docRef, listing);
        });
        await newBatch.commit();

        res.json({ success: true, message: 'Listings seeded successfully' });
    } catch (error) {
        console.error('Error seeding listings:', error);
        res.status(500).json({ success: false, error: error.message });
    }
}); 