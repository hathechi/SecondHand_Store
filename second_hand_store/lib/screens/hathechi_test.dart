import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Nav(),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      // color: Colors.amber,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 500,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          scale: 0.5,
                                          image: AssetImage(
                                            'assets/images/avatar.png',
                                          )),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          scale: 0.5,
                                          image: AssetImage(
                                            'assets/images/avatar.png',
                                          )),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          scale: 0.5,
                                          image: AssetImage(
                                            'assets/images/avatar.png',
                                          )),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.pink,
                              width: 500,
                              height: double.infinity,
                              child: Image.network(
                                'https://funkylife.in/wp-content/uploads/2023/02/cute-girl-pic-2-1024x1024.jpg',
                                width: 400,
                                height: 500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 500,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 50),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(right: 350),
                              child: const Text(
                                'Raven Hoodie With Black colored Design',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 300,
                              margin: const EdgeInsets.only(top: 50),
                              color: Colors.amber,
                              padding: const EdgeInsets.only(right: 350),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      // color: Colors.amber,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 500,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 500,
                                  // height: 300,
                                  child: Text(
                                    'Product Description',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 600,
                                    height: 300,
                                    margin: const EdgeInsets.only(top: 20),
                                    color: Colors.blue,
                                    child: const Text('abc'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 500,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: Container(
                        margin: const EdgeInsets.all(80),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(20)),
                        width: 200,
                        height: 300,
                        child: const Center(child: Text('Image')),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 300,
                      height: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      width: 300,
                      height: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      width: 300,
                      height: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      width: 300,
                      height: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Nav extends StatelessWidget {
  const Nav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: const Text('LOGO'),
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Shop"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Men"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Women"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Combos"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Joggers"),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: 'Search',
                alignLabelWithHint: true,
                hintStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.only(left: 16),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.2),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: const Icon(Icons.facebook_outlined),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: const Icon(Icons.youtube_searched_for),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: const Icon(Icons.telegram),
            ),
          ],
        ),
      ],
    );
  }
}
