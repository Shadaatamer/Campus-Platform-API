import React from "react";

export default function SwitchToggle({ value, onChange }) {
  return (
    <div
      style={{
        display: "flex",
        backgroundColor: "#f1f1f1",
        padding: "5px",
        borderRadius: "30px",
        width: "240px",
        margin: "0 auto",
      }}
    >
      <button
        onClick={() => onChange("student")}
        style={{
          flex: 1,
          padding: "10px",
          borderRadius: "25px",
          fontWeight: "600",
          border: "none",
          background: value === "student" ? "white" : "transparent",
          boxShadow: value === "student" ? "0 2px 5px rgba(0,0,0,0.2)" : "none",
        }}
      >
        Student
      </button>

      <button
        onClick={() => onChange("admin")}
        style={{
          flex: 1,
          padding: "10px",
          borderRadius: "25px",
          fontWeight: "600",
          border: "none",
          background: value === "admin" ? "white" : "transparent",
          boxShadow: value === "admin" ? "0 2px 5px rgba(0,0,0,0.2)" : "none",
        }}
      >
        Admin
      </button>
    </div>
  );
}
