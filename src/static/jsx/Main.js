const { Button } = window['material-ui'];

function Dyoneus() {
  return (
      <div>
        <Button variant="contained" color="primary">Es klappt!</Button>
      </div>
  );
}

ReactDOM.render(<Dyoneus/>, document.getElementById('root'));
