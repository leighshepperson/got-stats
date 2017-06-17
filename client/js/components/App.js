
import React from 'react';
import Relay from 'react-relay';

class App extends React.Component {
  render() {
    const [book, ...books] = this.props.root.books.edges;

    return (
      <div>
        <h1>Book list</h1>
        {book.node.name}
      </div>
    );
  }
}

export default Relay.createContainer(App, {
  fragments: {
    root: () => Relay.QL`
      fragment on Root {
        books(first: 1) {
          edges{
            node{
              name
            }
          }
        }
      }
    `,
  },
});
