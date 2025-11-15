import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0EA5E9);
const Color secondaryColor = Color(0xFF1E40AF);
const Color accentColor = Color(0xFFF59E0B);

const String appName = 'CampusOwl';

class NavigationItem {
  final String name;
  final IconData? icon;
  final String? asset; // path to SVG asset (preferred)

  const NavigationItem({required this.name, this.icon, this.asset});
}

const List<NavigationItem> navigationItems = [
  NavigationItem(name: 'Home', asset: 'assets/icons/home.svg'),
  NavigationItem(name: 'Notes', asset: 'assets/icons/book_open.svg'),
  NavigationItem(name: 'Services', asset: 'assets/icons/map_pin.svg'),
  NavigationItem(name: 'Jobs', asset: 'assets/icons/briefcase.svg'),
  NavigationItem(name: 'Focus', asset: 'assets/icons/clock.svg'),
];

// Notes
class Note {
  final int id;
  final String title;
  final String subject;
  final String author;
  final int likes;
  final int comments;
  final String content;

  const Note({
    required this.id,
    required this.title,
    required this.subject,
    required this.author,
    required this.likes,
    required this.comments,
    required this.content,
  });
}

const List<Note> dummyNotes = [
  Note(
    id: 1,
    title: 'Quantum Physics Lecture Notes',
    subject: 'Physics',
    author: 'Jane Doe',
    likes: 128,
    comments: 12,
    content: '''
Quantum physics is the study of matter and energy at its most fundamental level. It aims to uncover the properties and behaviors of the very building blocks of nature. While many quantum experiments examine very small objects, such as electrons and photons, quantum phenomena are all around us, acting on every scale. Key concepts include:

- Wave-particle duality: This principle states that every particle or quantum entity may be described as either a particle or a wave.
- Superposition: A quantum system can be in multiple states at the same time until it is measured.
- Entanglement: A phenomenon where two or more quantum particles are linked in such a way that their fates are intertwined, no matter how far apart they are. Measuring a property of one particle instantly influences the other.
- Quantization: In the quantum world, many properties like energy and momentum are quantized, meaning they can only take on discrete values.
'''
  ),
  Note(
    id: 2,
    title: 'Data Structures & Algorithms',
    subject: 'CS',
    author: 'John Smith',
    likes: 256,
    comments: 25,
    content: '''
Data Structures are a way of organizing and storing data so that they can be accessed and worked with efficiently. They define the relationship between the data, and the operations that can be performed on the data.

Key Data Structures:
- Arrays: A collection of items stored at contiguous memory locations.
- Linked Lists: A linear data structure where elements are not stored at contiguous memory locations but are linked using pointers.
- Stacks: A linear data structure which follows a particular order in which the operations are performed. The order is LIFO (Last In, First Out).
- Queues: A linear structure which follows a particular order in which the operations are performed. The order is FIFO (First In, First Out).
- Trees: A hierarchical data structure that consists of nodes connected by edges.
- Graphs: A non-linear data structure consisting of nodes and edges.

Algorithms are a set of rules or instructions to be followed in calculations or other problem-solving operations. The efficiency of an algorithm is measured by its time complexity and space complexity.
'''),
];

// Messages for group chat
class ChatMessage {
  final int id;
  final String sender;
  final String text;
  final String time;
  final bool isRead;
  final Map<String, int>? reactions;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    this.isRead = false,
    this.reactions,
  });
}

// Groups
class Group {
  final int id;
  final String name;
  final String subject;
  final int members;

  const Group({
    required this.id,
    required this.name,
    required this.subject,
    required this.members,
  });
}

const List<Group> dummyGroups = [
  Group(id: 1, name: 'Computer Science Study Group', subject: 'CS', members: 12),
  Group(id: 2, name: 'Physics Discussion Forum', subject: 'Physics', members: 8),
];

const List<Map<int, List<ChatMessage>>> dummyChats = [
  // Group 1 chats
  {
    1: [
      ChatMessage(
        id: 1,
        sender: 'Alice',
        text: 'Hey everyone, can someone explain Quicksort?',
        time: '10:30',
        isRead: true,
        reactions: {'thumb_up': 2, 'wat': 1},
      ),
      ChatMessage(
        id: 2,
        sender: 'Bob',
        text: 'Sure! Quicksort is a divide and conquer algorithm. It picks a pivot and partitions the array.',
        time: '10:32',
        isRead: true,
      ),
    ],
  },
  // Group 2 chats
  {
    2: [
      ChatMessage(
        id: 1,
        sender: 'Charlie',
        text: 'Quantum entanglement is so confusing!',
        time: '11:00',
        isRead: true,
      ),
      ChatMessage(
        id: 2,
        sender: 'Dana',
        text: 'It really is. Think of it as two particles being connected, even across the universe.',
        time: '11:05',
        isRead: false,
      ),
    ],
  },
];

// Jobs
class Job {
  final int id;
  final String title;
  final String pay;
  final String location;
  final String type;
  final double rating;

  const Job({
    required this.id,
    required this.title,
    required this.pay,
    required this.location,
    required this.type,
    required this.rating,
  });
}

const List<Job> dummyJobs = [
  Job(id: 1, title: 'Part-time Graphic Designer', pay: '₹8,000/month', location: 'Remote', type: 'Design', rating: 4.8),
  Job(id: 2, title: 'Math Tutor for Class 12', pay: '₹500/hr', location: 'On-campus', type: 'Tutoring', rating: 4.9),
  Job(id: 3, title: 'Content Writer', pay: '₹0.50/word', location: 'Remote', type: 'Writing', rating: 4.5),
  Job(id: 4, title: 'Photography Assistant', pay: '₹300/event', location: 'On-campus', type: 'Photography', rating: 4.7),
];

// Mess
class Mess {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final String distance;
  final String hours;
  final String description;
  final Map<String, Map<String, List<String>>> menu;
  final List<String> services;
  final List<MessReview> reviews;
  final List<String> images;

  const Mess({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.distance,
    required this.hours,
    required this.description,
    required this.menu,
    required this.services,
    required this.reviews,
    required this.images,
  });
}

class MessReview {
  final String author;
  final String comment;
  final double rating;

  const MessReview({
    required this.author,
    required this.comment,
    required this.rating,
  });
}

const List<Mess> dummyMesses = [
  Mess(
    id: 1,
    name: 'Green Leaf Mess',
    cuisine: 'Indian',
    rating: 4.6,
    distance: '0.8 km',
    hours: '7 AM - 10 PM',
    description: 'Authentic Indian cuisine with fresh local ingredients. Known for our thalis and vegetarian options.',
    menu: {
      'Monday': {
        'Lunch': ['Rice', 'Dal Tadka', 'Aloo Gobi', 'Raita', 'Chapati'],
        'Dinner': ['Rajma', 'Jeera Rice', 'Mixed Vegetables', 'Pickle', 'Roti'],
      },
      'Tuesday': {
        'Lunch': ['Chole', 'Purit', 'Onion Pakoras', 'Salad', 'Naan'],
        'Dinner': ['Paneer Butter Masala', 'Basmati Rice', 'Cauliflower Sabzi', 'Dessert', 'Bread'],
      },
      // Add more days...
    },
    services: ['Home Delivery', 'Special Diets', 'Catering'],
    reviews: [
      MessReview(
        author: 'Rahul K.',
        comment: 'Amazing food and great service. Highly recommended!',
        rating: 5.0,
      ),
      MessReview(
        author: 'Priya M.',
        comment: 'The thali is delicious and value for money.',
        rating: 4.5,
      ),
    ],
    images: [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7446?w=800',
      'https://images.unsplash.com/photo-1596797038530-2c107229654b?w=800',
    ],
  ),
];

// Tiffin
class Tiffin {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final String distance;
  final String description;
  final Map<String, String> menu;
  final List<Map<String, dynamic>> plans;
  final List<String> deliveryAreas;
  final List<String> howItWorks;
  final List<TiffinReview> reviews;
  final List<String> images;

  const Tiffin({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.distance,
    required this.description,
    required this.menu,
    required this.plans,
    required this.deliveryAreas,
    required this.howItWorks,
    required this.reviews,
    required this.images,
  });
}

class TiffinReview {
  final String author;
  final String comment;
  final double rating;

  const TiffinReview({
    required this.author,
    required this.comment,
    required this.rating,
  });
}

const List<Tiffin> dummyTiffins = [
  Tiffin(
    id: 1,
    name: 'Healthy Bite Tiffins',
    cuisine: 'North Indian',
    rating: 4.7,
    distance: '1.2 km',
    description: 'Fresh, nutritious meals delivered to your doorstep.',
    menu: {
      'Monday': 'Rajma-Rice|Paneer Sabzi|Raita',
      'Tuesday': 'Chicken Curry|Basmati Rice|Dal',
      'Wednesday': 'Butter Chicken|Naan Salad',
      // Add more...
    },
    plans: [
      {'name': 'Basic Plan', 'daily': false, 'price': '₹80/meal'},
      {'name': 'Weekly Plan', 'daily': true, 'price': '₹300/week'},
      {'name': 'Monthly Plan', 'daily': true, 'price': '₹2,000/month'},
    ],
    deliveryAreas: ['Block A', 'Block B', 'Hostels 1-5'],
    howItWorks: ['Choose Plan', 'Select Meals', 'Order & Pay', 'Get Delivered'],
    reviews: [
      TiffinReview(
        author: 'Arjun S.',
        comment: 'Best tiffin service on campus. Always fresh!',
        rating: 4.5,
      ),
    ],
    images: [
      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=800',
      'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=800',
    ],
  ),
];
