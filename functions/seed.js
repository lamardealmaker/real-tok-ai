const admin = require('firebase-admin');
const serviceAccount = require('./real-tok-ai-firebase-adminsdk-fbsvc-5c126b035f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

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
    },
    {
        listingId: "TX-234567",
        address: {
            street: "789 East 6th Street",
            city: "Austin",
            state: "TX",
            zip: "78702"
        },
        price: 850000,
        propertyType: "Historic Bungalow",
        bedrooms: 3,
        bathrooms: 2,
        squareFeet: 1650,
        description: "Charming historic bungalow in the heart of East Austin. Beautifully restored with modern amenities while maintaining its original character. Features include hardwood floors, high ceilings, and a wrap-around porch perfect for enjoying Austin evenings.",
        features: [
            "Historic Character",
            "Wrap-around Porch",
            "Original Hardwood Floors",
            "Updated Kitchen",
            "Fenced Yard",
            "Walk to Restaurants"
        ],
        photos: realEstatePhotos.traditional,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "David Martinez",
            brokerage: "East Austin Realty"
        },
        likeCount: 0
    },
    {
        listingId: "TX-456789",
        address: {
            street: "1010 West Lynn Street",
            city: "Austin",
            state: "TX",
            zip: "78703"
        },
        price: 4500000,
        propertyType: "Modern Mansion",
        bedrooms: 7,
        bathrooms: 6.5,
        squareFeet: 6800,
        description: "Extraordinary modern mansion in Clarksville. This architectural marvel offers unparalleled luxury with smart home technology throughout, a resort-style pool, and breathtaking downtown views from multiple terraces.",
        features: [
            "Smart Home Technology",
            "Resort-style Pool",
            "Downtown Views",
            "Media Room",
            "Chef's Kitchen",
            "Electric Car Charging"
        ],
        photos: realEstatePhotos.luxury,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Alexandra Kim",
            brokerage: "Luxury Austin Properties"
        },
        likeCount: 0
    },
    {
        listingId: "TX-678901",
        address: {
            street: "2525 South Lamar Blvd",
            city: "Austin",
            state: "TX",
            zip: "78704"
        },
        price: 725000,
        propertyType: "Modern Loft",
        bedrooms: 2,
        bathrooms: 2,
        squareFeet: 1200,
        description: "Stunning industrial-chic loft in South Austin. This open-concept space features soaring 16-foot ceilings, exposed ductwork, polished concrete floors, and a private balcony overlooking the vibrant South Lamar corridor.",
        features: [
            "Industrial Design",
            "High Ceilings",
            "Private Balcony",
            "Gated Parking",
            "Dog Park",
            "Bike Storage"
        ],
        photos: realEstatePhotos.modern,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Tom Wilson",
            brokerage: "Urban Spaces ATX"
        },
        likeCount: 0
    },
    {
        listingId: "TX-890123",
        address: {
            street: "4040 Lake Austin Blvd",
            city: "Austin",
            state: "TX",
            zip: "78703"
        },
        price: 5750000,
        propertyType: "Waterfront Estate",
        bedrooms: 8,
        bathrooms: 7.5,
        squareFeet: 8200,
        description: "Magnificent waterfront estate with private boat dock. This Mediterranean-style mansion offers the ultimate Lake Austin lifestyle with expansive water views, a private beach area, and resort-style outdoor living spaces.",
        features: [
            "Private Boat Dock",
            "Beach Area",
            "Outdoor Kitchen",
            "Guest House",
            "Wine Cellar",
            "Elevator"
        ],
        photos: realEstatePhotos.luxury,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Victoria Palmer",
            brokerage: "Lake Austin Luxury"
        },
        likeCount: 0
    },
    {
        listingId: "TX-012345",
        address: {
            street: "3131 Domain Drive",
            city: "Austin",
            state: "TX",
            zip: "78758"
        },
        price: 550000,
        propertyType: "Smart Condo",
        bedrooms: 2,
        bathrooms: 2,
        squareFeet: 1100,
        description: "Ultra-modern smart condo in The Domain. This tech-forward home features voice-controlled lighting, automated climate control, and a sleek modern design. Perfect for the tech-savvy professional seeking luxury amenities.",
        features: [
            "Smart Home Features",
            "Concierge Service",
            "Rooftop Lounge",
            "Fitness Center",
            "EV Charging",
            "Package Room"
        ],
        photos: realEstatePhotos.modern,
        status: "Active",
        listingDate: new Date().toISOString(),
        agent: {
            name: "Ryan Chang",
            brokerage: "Tech City Realty"
        },
        likeCount: 0
    }
];

async function seedListings() {
    try {
        // Clear existing listings
        const existingListings = await db.collection('listings').get();
        const batch = db.batch();
        existingListings.docs.forEach((doc) => {
            batch.delete(doc.ref);
        });
        await batch.commit();
        console.log('Cleared existing listings');

        // Add new listings
        const newBatch = db.batch();
        testListings.forEach((listing) => {
            const docRef = db.collection('listings').doc(listing.listingId);
            newBatch.set(docRef, listing);
        });
        await newBatch.commit();
        console.log('Added new listings successfully');

    } catch (error) {
        console.error('Error seeding listings:', error);
    }
    process.exit();
}

seedListings(); 