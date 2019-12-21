class Seat {
  int row;
  int column;
  Status seatStatus;

  Seat({this.row, this.column, this.seatStatus});
}

enum Status {
  BOOKED, AVAILABLE, SELECTED, NO_SEAT
}