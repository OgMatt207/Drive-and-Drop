# Drive and Drop

A top-down delivery/driving game built in **Delphi (Object Pascal, VCL)** for my Grade 12 IT Practical Assessment Task (PAT), 2025.

Play the compiled build on [itch.io](https://ogmatt.itch.io/drive-and-drop).

## Overview

You manage a delivery business: buy/upgrade vehicles, pick up cargo, and drop it off around a map while managing fuel. An admin panel provides a separate view for managing users and data.

**Login credentials (demo/admin access):**
- Username: `Admin`
- Password: `AdminPassword`

## Project structure

### Screens (VCL forms)
| File | Purpose |
|---|---|
| `Login.pas` / `Login.dfm` | User login screen |
| `SignUp.pas` / `SignUp.dfm` | New user registration |
| `Admin.pas` / `Admin.dfm` | Admin dashboard |
| `Game.pas` / `Game.dfm` | Main gameplay loop and map rendering |
| `DeliveryTab.pas` / `DeliveryTab.dfm` | Delivery tracking UI |
| `Garage.pas` / `Garage.dfm` | Vehicle garage/upgrades |
| `VehicleDealership.pas` / `VehicleDealership.dfm` | Buying/selling vehicles |
| `DataBase.pas` / `DataBase.dfm` | Database connection layer |

### Game object classes
| File | Purpose |
|---|---|
| `clsGameObject.pas` | Base class for in-game entities |
| `clsVehicle.pas` | Vehicle data/state |
| `clsVehicleController.pas` | Vehicle movement/input handling |
| `clsDelivery.pas` | Delivery job logic |
| `clsDeliveryPoint.pas` | Pickup/drop-off point logic |

### Data
- `Drive and Drop.mdb` — Microsoft Access database storing users, vehicles, and delivery data (queried via Jet SQL)
- `Map.txt` — map layout data

### Assets
- `Vehicles/` — directional sprites for each vehicle type
- `Button UI/` — UI button sprites
- Root-level `.png`/`.jpeg` files — world tiles, icons, and gauges

## Building

Open `Drive_and_Drop.dproj` in Embarcadero Delphi / RAD Studio and build. Requires the VCL and a Jet/ACE OLE DB provider (or equivalent) to read the `.mdb` file at runtime.

## Notes

This was a solo school assessment project — the login/admin system uses simple credential checks rather than production-grade security, since the PAT brief focused on demonstrating OOP structure and database integration rather than security hardening.
